// Copyright 2016 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#include "filesystem/scoped_temp_dir.h"

#include "filesystem/build_config.h"

// mkdtemp - required include file
#if defined(OS_MACOSX)
#include <unistd.h>
#elif defined(OS_WIN)
#include <windows.h>
#undef CreateDirectory
#include "filesystem/file.h"
#else
#include <stdlib.h>
#endif

#include "filesystem/directory.h"
#include "filesystem/file_descriptor.h"
#include "filesystem/path.h"

namespace filesystem {

ScopedTempDir::ScopedTempDir() = default;

ScopedTempDir::ScopedTempDir(std::string parent_path) {
#if defined(OS_WIN)
  if (parent_path.empty()) {
    char buffer[MAX_PATH];
    DWORD ret = GetTempPathA(MAX_PATH, buffer);
    if (ret > MAX_PATH || (ret == 0)) {
      directory_path_ = "";
      return;
    }
    parent_path = {buffer};
  }
  do {
    directory_path_ = parent_path.ToString() + "\\" + fxl::GenerateUUID();
  } while (IsFile(directory_path_) || IsDirectory(directory_path_));
  if (!CreateDirectory(directory_path_)) {
    directory_path_ = "";
  }
#else
  if (parent_path.empty()) {
    const char* env_var = getenv("TMPDIR");
    parent_path = env_var ? std::string{env_var} : "/tmp";
  }
  // mkdtemp replaces "XXXXXX" so that the resulting directory path is unique.
  directory_path_ = parent_path + "/temp_dir_XXXXXX";
  if (!CreateDirectory(parent_path) || !mkdtemp(&directory_path_[0])) {
    directory_path_ = "";
  }
#endif
}

ScopedTempDir::~ScopedTempDir() {
  if (directory_path_.size()) {
    DeletePath(directory_path_, true);
  }
}

const std::string& ScopedTempDir::path() {
  return directory_path_;
}

bool ScopedTempDir::NewTempFile(std::string* output) {
#if defined(OS_WIN)
  char buffer[MAX_PATH];
  UINT ret = GetTempFileNameA(directory_path_.c_str(), "", 0, buffer);
  output->swap(std::string(buffer));
  return (ret != 0);
#else
  // mkstemp replaces "XXXXXX" so that the resulting file path is unique.
  std::string file_path = directory_path_ + "/XXXXXX";
  filesystem::Descriptor fd(mkstemp(&file_path[0]));
  if (!fd.is_valid()) {
    return false;
  }
  output->swap(file_path);
  return true;
#endif
}

}  // namespace filesystem
