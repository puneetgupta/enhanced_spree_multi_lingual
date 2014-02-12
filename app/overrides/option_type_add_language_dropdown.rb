Deface::Override.new(
  :virtual_path => "spree/admin/option_types/edit",
  :insert_before   => "fieldset",
  :text         => '<%= render "spree/admin/shared/language_dropdown", :object => @option_type -%>',
  :name         => "option_type_add_language_dropdown"
)
