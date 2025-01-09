# frozen_string_literal: true

module AccessControlHelper
    module LinkHelper

        def snake(clazz)
            "#{clazz.to_s.underscore}"
        end

        def link_to_edit(link_text, resource)
          if can? :edit,resource
              path_helper = "edit_#{snake(resource.class)}_path"
              path = self.send(path_helper, resource)
              link_to(link_text, path)
          else
              "<!-- link omitted -->"
          end
        end

        def link_to_new(link_text, clazz, path_args = {})
            if can? :create, clazz
                path_helper = "new_#{snake(clazz)}_path"
                path = self.send(path_helper, path_args)
                link_to(link_text, path)
            else
                "<!-- link omitted -->"
            end
        end



    end
end
