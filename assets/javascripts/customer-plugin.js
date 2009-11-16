jQuery.noConflict();
jQuery(document).ready(function() {
  jQuery('#customer_cpf').mask('999.999.999-99')
  jQuery('.phone').mask('+55 (99) 9999-9999')

  jQuery('#main form').validate({
    rules: {
      'customer[name]': 'required',
      'customer[cpf]': 'cpf'
    },
    messages: {
      'customer[name]': 'Informe um nome',
      'customer[cpf]': 'Informe um CPF válido'
    },
    errorElement: 'span'
  });
});

