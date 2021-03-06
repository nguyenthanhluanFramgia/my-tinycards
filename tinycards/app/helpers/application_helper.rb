module ApplicationHelper
  def link_to_add_fields form_builder, association
    association_string = association.to_s
    kclass = form_builder.object.class.reflect_on_association(association).klass
    fields = form_builder.fields_for(association, kclass.new, child_index: "new_" + association_string) do |builder|
      render(association_string.singularize + "_fields", f: builder)
    end

    link_to "javascript:void(0)", class: "add", id: "btn-addCard",
      onclick: "add_fields(this,\"#{association}\", \"#{escape_javascript(fields)}\")" do
      "<i class=\"add\" aria-hidden=\"true\">+</i> ".html_safe
    end
  end
end
