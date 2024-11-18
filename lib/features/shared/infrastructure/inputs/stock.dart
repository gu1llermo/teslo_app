// Aquí mi versión

import 'package:formz/formz.dart';

// Define input validation errors
enum StockError { empty, negative, format }

// Extend FormzInput and provide the input type and error type.
class Stock extends FormzInput<String, StockError> {
  // Call super.pure to represent an unmodified form input.
  const Stock.pure() : super.pure('0.0');

  // Call super.dirty to represent a modified form input.
  const Stock.dirty(super.value) : super.dirty();

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == StockError.empty) {
      return 'El valor es requerido';
    }
    if (displayError == StockError.negative) {
      return 'El valor no puede ser negativo';
    }
    if (displayError == StockError.format) {
      return 'Formato de número no permitido';
    }

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  StockError? validator(String value) {
    value = value.trim();
    if (value.isEmpty) return StockError.empty;
    double doubleValue = 0.0;
    try {
      doubleValue = double.parse(value);
    } catch (e) {
      return StockError.format;
    }

    if (doubleValue < 0.0) return StockError.negative;

    return null;
  }
}
