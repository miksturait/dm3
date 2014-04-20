module Formtastic
  module Inputs
    class DaterangeInput < Formtastic::Inputs::StringInput
      def to_html
        input_wrapping do
          label_html <<
              builder.text_field("#{method}_begin".to_sym, class: 'daterangepicker start hide', disabled: true) <<
              builder.text_field(method, input_html_options.merge(style: 'width: 12em;', readonly: true)) <<
              builder.text_field("#{method}_end".to_sym, class: 'daterangepicker end hide', disabled: true)
        end
      end
    end

    class HstoreInput < Formtastic::Inputs::StringInput
    end

    class Select2Input < Formtastic::Inputs::SelectInput
    end
  end
end