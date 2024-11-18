// Aquí mi versión

import 'package:formz/formz.dart';

// Define input validation errors
enum PriceError { empty, negative, format }

// Extend FormzInput and provide the input type and error type.
class Price extends FormzInput<String, PriceError> {
  // Call super.pure to represent an unmodified form input.
  const Price.pure() : super.pure('0.0');

  // Call super.dirty to represent a modified form input.
  const Price.dirty(super.value) : super.dirty();

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == PriceError.empty) {
      return 'El valor es requerido';
    }
    if (displayError == PriceError.negative) {
      return 'El valor no puede ser negativo';
    }
    if (displayError == PriceError.format) {
      return 'Formato de número no permitido';
    }

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  PriceError? validator(String value) {
    value = value.trim();
    if (value.isEmpty) return PriceError.empty;
    double doubleValue = 0.0;
    try {
      doubleValue = double.parse(value);
    } catch (e) {
      return PriceError.format;
    }

    if (doubleValue < 0.0) return PriceError.negative;

    return null;
  }
}


// import 'package:formz/formz.dart';

// // Define input validation errors
// enum PriceError { empty, negative }

// // Extend FormzInput and provide the input type and error type.
// class Price extends FormzInput<double, PriceError> {
//   // Call super.pure to represent an unmodified form input.
//   const Price.pure() : super.pure(0.0);

//   // Call super.dirty to represent a modified form input.
//   const Price.dirty(super.value) : super.dirty();

//   String? get errorMessage {
//     if (isValid || isPure) return null;

//     if (displayError == PriceError.empty) {
//       return 'El valor es requerido';
//     }
//     if (displayError == PriceError.negative) {
//       return 'Tiene que ser cero ó mayor';
//     }

//     return null;
//   }

//   // Override validator to handle validating a given input value.
//   @override
//   PriceError? validator(double value) {
//     if (value.toString().trim().isEmpty) return PriceError.empty;

//     if (value < 0.0) return PriceError.negative;

//     return null;
//   }
// }




