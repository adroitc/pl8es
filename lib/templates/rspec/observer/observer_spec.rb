require 'spec_helper'

<% module_namespacing do -%>
describe <%= class_name %>Observer, <%= type_metatag(:observer) %> do
	pending "add some examples to (or delete) #{__FILE__}"
end
<% end -%>