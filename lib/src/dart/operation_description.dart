part of tensorflow;

/// A builder for [Operation]s in a [Graph].
class OperationDescription<T> {
  final Graph _graph;
  final String type, name;
  final int _pointer;
  int _index = 0;

  static int _OperationDescription_new(int graph, String type, String name)
      native "OperationDescription_new";

  OperationDescription._(this._graph, this.type, this.name)
      : _pointer = _OperationDescription_new(_graph._pointer, type, name);

  /// Ensure that the operation does not execute before the control operation does.
  void addControlInput(Operation control)
      native "OperationDescription_add_control_input";

  void _addInput(Output control, int index)
      native "OperationDescription_add_input";

  /// Returns the builder to create an operation.
  void addInput(Output control) {
    _addInput(control, _index++);
  }

  void addInputList(List<Output> inputs)
      native "OperationDescription_add_input_list";

  int _finish(Type tensorFlowExceptionType)
      native "OperationDescription_finish";

  /// Add the [Operation] being built to the [Graph].
  Operation<T> finish() =>
      new Operation<T>._fromPointer(_finish(TensorFlowException), _graph);

  Tuple2<int, String> _setAttrTensor(String name, Tensor value)
      native "OperationDescription_set_attr_tensor";

  void setAttrTensor(String name, Tensor value) {
    var result = _setAttrTensor(name, value);
    var code = _codeFrom(result.item1);
    if (code != Code.ok) throw new TensorFlowException(code, result.item2);
  }

  void setAttrTensorList(String name, List<Tensor> value) native "";

  void setAttrString(String name, String value) native "";

  void setAttrStringList(String name, List<String> value) native "";

  void setAttrBool(String name, bool value) native "";

  void setAttrBoolList(String name, List<bool> value) native "";

  void setAttrInt(String name, int value) native "";

  void setAttrIntList(String name, List<int> value) native "";

  void setAttrFloat(String name, double value) native "";

  void setAttrFloatList(String name, List<double> value) native "";

  void setAttrLong(String name, int value) native "";

  void setAttrLongList(String name, int value) native "";

  void setAttrShape(String name, Shape value) native "";

  void setAttrShapeList(String name, List<Shape> value) native "";

  void _setAttrType(String name, int value)
      native "OperationDescription_set_attr_type";

  void setAttrType(String name, DataType value) =>
      _setAttrType(name, value.value);

  void _setAttrTypeList(String name, Int32List value)
      native "OperationDescription_set_attr_type_list";

  void setAttrTypeList(String name, List<DataType> value) => _setAttrTypeList(
      name, new Int32List.fromList(value.map((t) => t.value).toList()));

  void setDevice(String device) native "";
}