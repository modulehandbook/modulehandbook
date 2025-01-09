# frozen_string_literal: true

module AccessControlHelper
    module LinkHelper

        def snake(clazz)
            "#{clazz.to_s.underscore}"
        end

        def link_to_edit(link_text, resource, link_args = {})
          if can? :edit,resource
              path_helper = "edit_#{snake(resource.class)}_path"
              path = self.send(path_helper, resource)
              link_to(link_text, path, link_args)
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

        def link_to_delete(link_text, resource, confirmation = 'Are you sure?')
            if can? :destroy, resource
                snake = snake(resource.class)
                link_to(link_text, resource, id: "delete_#{snake}_#{resource.id}", data: { turbo_method: :delete, turbo_confirm: confirmation })
            else
                "<!-- delete link omitted -->"
            end
        end
             


    end
end
