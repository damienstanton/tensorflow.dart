import 'package:tensorflow/tensorflow.dart' as tf;

void main() {
  var x = tf.randomUniform(tf.constant([1, 2]));
  print(x.run());
}
