import 'dart:async';

import 'package:rxdart/rxdart.dart';

import 'login_validators.dart';

//Para mandar información a cualquier vista
class LoginBloc with Validators {

  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  // Recuperar los datos del Stream
  Stream<String> get emailStream => _emailController.stream.transform(validarEmail);
  Stream<String> get passwordStream => _passwordController.stream.transform( validarPassword);

  Stream<bool> get formValidStream =>
    Observable.combineLatest2(emailStream, passwordStream, (e, p) => true);

  // Insertar valores al Stream
  Function(String) get changeEmail    => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  //Obtener el ultimo valor tomado del stream
  String get email => _emailController.value;
  String get password => _passwordController.value;


  //Cerrar métodos

  dispose() {
    _emailController?.close();  
    _passwordController?.close();
  }

}