import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'dart:async'; //importa el timer 

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}


class _LoginScreenState extends State<LoginScreen> {
//crear variable para mostrar u ocultar la contraseña
  bool _obscureText = true;
  //SMI: es una clase que se utiliza para controlar la animación de Rive desde el código de Flutter, es el cerebro de la animación de Rive, es decir, es el encargado de controlar las variables y los triggers de la animación de Rive desde el código de Flutter
  //crear el cerebro de la animación de Rive
  StateMachineController? _controller;
  //SMI: State Machine Input: es una variable que se utiliza para controlar la animación de Rive desde el código de Flutter
  SMIBool? _isChecking; //variable para controlar la animación de Rive cuando el usuario está escribiendo en el campo de email
  SMIBool? _isHandsUp; //variable para controlar la animación de Rive cuando el usuario está escribiendo en el campo de password
  SMITrigger? _trigSuccess; //variable para controlar la animación de Rive cuando el usuario hace clic en el botón de login
  SMITrigger? _trigFail; //variable para controlar la animación de Rive cuando el usuario hace clic en el botón de login y la autenticación falla

//2.1 variable para el recorrido de la mirada
 SMINumber? _numLook;


  //paso 1.1: crear variables para el focus de los campos de texto
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  //3.1 timer para detener mirada 
  Timer? _typingDebounce;

  // 4.1 controllers para manipular texto escrito
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  //4.2 errores para mostrar en la ui
  String? _emailError;
  String? _passwordError;

  // 4.3 Validadores
  bool isValidEmail(String email) {
    final re = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    return re.hasMatch(email);
  }

  bool isValidPassword(String pass) {
    // mínimo 8, una mayúscula, una minúscula, un dígito y un especial
    final re = RegExp(
      r'^(?=.[a-z])(?=.[A-Z])(?=.\d)(?=.[^A-Za-z0-9]).{8,}$',
    );
    return re.hasMatch(pass);
  }

  // 4.4 Acción al botón
  void _onLogin() {
  final email = _emailController.text.trim(); //elimina espacios en blanco
  final pass = _passwordController.text;

    // Recalcular errores
    final eError = isValidEmail(email) ? null : 'Email inválido';
    final pError =
        isValidPassword(pass)
            ? null
            : 'Mínimo 8 caracteres, 1 mayúscula,  1 minúscula, 1 número y 1 caracter especial';

    // 4.5 Para avisar que hubo un cambio
    setState(() {
    _emailError = eError;
    _passwordError = pError;
    });

    // 4.6 Cerrar el teclado y bajar manos
    FocusScope.of(context).unfocus();
    _typingDebounce?.cancel();
    _isChecking?.change(false);
    _isHandsUp?.change(false);
    _numLook?.value = 50.0; // Mirada neutral

    // 4.7 Activar triggers
    if (eError == null && pError == null) {
      _trigSuccess?.fire();
    } else {
      _trigFail?.fire();
    }
  }


  
  //paso 1.2: Listenrs para FocusNodes (Oyentes/Chismosos)
  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener(() {
      if(_emailFocusNode.hasFocus) {
        if(_isHandsUp != null){
          //No tapes los ojos al ver email
          _isHandsUp?.change(false);
          //2.2 Mirada Neutral
          _numLook?.value = 50.0;
        }
      }
    }); 
    _passwordFocusNode.addListener(() {
      _isHandsUp?.change(_passwordFocusNode.hasFocus); //Levantar las manos al ver password
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;//obtenemos el tamaño de la pantalla para ajustar la animación y los campos de texto
    return Scaffold(
      body: SingleChildScrollView(   //Error de overflow
        child: Padding( //agregamos un padding para que la animación y los campos de texto no estén pegados a los bordes de la pantalla
          padding: const EdgeInsets.symmetric(horizontal: 20.0),//padding horizontal de 20 para que la animación y los campos de texto no estén pegados a los bordes de la pantalla
          child: Column(
            children: [
              Expanded(
                child: RiveAnimation.asset('animated_login_bear.riv',//agregamos la animación de Rive en la parte superior de la pantalla
                stateMachines:['Login Machine'],//especificamos el nombre de la máquina de estados que queremos utilizar para controlar la animación de Rive
                onInit: (artboart){
                  _controller = StateMachineController.fromArtboard(artboart, 'Login Machine');
                  if(_controller == null) return;
                  artboart.addController(_controller!);
                  //vinculamos las variables de la animación de Rive con las variables de Flutter para poder controlar la animación desde el código de Flutter
                  _isChecking = _controller!.findSMI('isChecking') as SMIBool;
                  _isHandsUp = _controller!.findSMI('isHandsUp') as SMIBool;
                  _trigSuccess = _controller!.findSMI('trigSuccess') as SMITrigger;
                  _trigFail = _controller!.findSMI('trigFail') as SMITrigger;
                  //2.2 Mirada Neutral
                  _numLook = _controller!.findSMI('numLook');
                },
                )),
              const SizedBox(height: 10), //separación entre la animación y el campo de email
              TextField(
                controller: _emailController, //asociamos el controlador de texto al campo de email
                //paso 1.3: asociar los focusNodes a los campos de texto
                focusNode: _emailFocusNode,
                onChanged: (value){
                 //asociamos el focusNode al campo de email
                  if(_isHandsUp != null){
                    //No tapes los ojos al ver email
                    //_isHandsUp!.change(false);
                  }
                  //Si isChecking no es null
                  if(_isChecking == null) return;
                  //Activar modo chismoso
                    _isChecking!.change(true); 
                    //2.4 implementar numLook
                    //Ajustes de limites de 0 a 100
                    //80 como medida de calibracion
                    final look = (value.length/80.0*100.0)
                    .clamp(0.0, 100.0); //clamp es el rango (abrazadera)
                    _numLook?.value = look;

                    //3.3 si vuelve a teclear reinicia el contador
                    
                    _typingDebounce?.cancel(); //cancela el timer anterior si el usuario sigue escribiendo
                    //crear un nuevo timer
                    _typingDebounce =Timer(
                      const Duration(seconds: 3), () {
                      //pasados 2 segundos sin teclear, vuelve a mirada neutra
                      if (!mounted) return; //verifica que el widget siga montado antes de actualizar el estado
                      _isChecking?.change(false); //desactiva el modo chismoso
                    });
                    
                    
                    //mirada neutra
                    //_isChecking?.change)false;


                },
                decoration: InputDecoration(
                  errorText: _emailError,
                  hintText: 'Email',
                  prefixIcon: const Icon(Icons.email),//icono de email para el campo de email
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12) //borde redondeado para el campo de email
                  )
                ),
              ),
              const SizedBox(height: 10), //separación entre el campo de email y el campo de password
              TextField(
                controller: _passwordController, //asociamos el controlador de texto al campo de password
                //paso 1.3: asociar los focusNodes a los campos de texto
                focusNode: _passwordFocusNode,
                onChanged: (value){
                  if(_isChecking != null){
                    //No quiero modo chismoso
                    //_isChecking!.change(false);
                  }
                  //Si isHandsUp no es null
                  if(_isHandsUp == null) return;
                  //Levantar las manos al ver password
                    _isHandsUp!.change(true); 
                },
                obscureText: _obscureText, //ocultamos la contraseña por defecto  
                decoration: InputDecoration(
                  errorText: 'Password',
                  hintText: 'Password',
                  prefixIcon: const Icon(Icons.lock),//icono de candado para el campo de password
                  suffixIcon: IconButton(
                    //if ternario
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off, //cambiamos el icono de ojo dependiendo de si la contraseña está oculta o no
                    ),
                    onPressed: () {
                      //refresca el icono
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ), 
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)//borde redondeado para el campo de password
                  )
                ),
              ),
              const SizedBox(height: 10), //separación entre el campo de password y el botón de login      
                    //texto de "olvide mi contraseña"
                    SizedBox(width:size.width,
                      child: const Text (
                        "forgot password?",
                        //alinearlo a la derecha
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          decoration:TextDecoration.underline, //subrayado para indicar que es un enlace
                        ),
                      )),
                MaterialButton(
                minWidth: size.width,
                height: 50,
                color: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)
                ),
                onPressed: (){},
                child: Text("Login", style: TextStyle(
                  color: Colors.white),
                ),
                ),       
                SizedBox(
                width: size.width,
                child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: (){},
                      child: const Text("Register",
                      style: TextStyle(
                        color: Colors.blueAccent,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                      )),
                    ),
                   ],
                  ),
                ),
              ],
              
          ),
        )
      ),
    );
  }

  //paso 1.4: limpiar los focusNodes para evitar fugas de memoria
  @override
  void dispose() {
    //4.11 liberar controller
    _emailController.dispose();
    _passwordController.dispose();
    //limpiar los focusNodes para evitar fugas de memoria
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _typingDebounce?.cancel();
    super.dispose();
  }
}