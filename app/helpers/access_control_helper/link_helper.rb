# frozen_string_literal: true

module AccessControlHelper
    module LinkHelper

        # todo: dry with method missing, see
        # https://stackoverflow.com/questions/49712163/ruby-module-that-delegates-methods-to-an-object
        def link_to_delete(link_text, resource, confirmation = 'Are you sure?')
            LinkGenerator.new(self).link_to_delete(link_text, resource, confirmation)
        end

        def link_to_edit(link_text, resource, options = {})
            LinkGenerator.new(self).link_to_edit(link_text, resource, options)
        end

        def link_to_new(link_text, clazz, path_args = {})
            LinkGenerator.new(self).link_to_new(link_text, clazz, path_args)
        end


        class LinkGenerator
            def initialize(controller_context)
                @controller_context = controller_context
            end

        def my_can?(*args)
            @controller_context.can?(*args)
        end

        def options_hash(opts)
            opts_with_default = Hash.new('')
            opts_with_default.merge(opts)
        end

        def snake(clazz)
            "#{clazz.to_s.underscore}"
        end

        def link_to_edit(link_text, resource, options = {})
          opt = options_hash(options)
          if my_can? :edit,resource
              snake = snake(resource.class)
              path_helper = "edit_#{snake}_path"
              path = @controller_context.send(path_helper, resource)
              link = @controller_context.link_to(link_text, path, id: "edit_#{snake}_#{resource.id}")
              link+opt[:suffix]
              #"#{link}#{opt[:suffix]}"
          else
              "<!-- edit link omitted -->"
          end
        end


        def link_to_new(link_text, clazz, path_args = {})
            if my_can? :create, clazz
                snake = snake(clazz)
                path_helper = "new_#{snake}_path"
                path = @controller_context.send(path_helper, path_args)
                @controller_context.link_to(link_text, path, id: "new_#{snake}")
            else
                "<!-- new link omitted -->"
            end
        end

        def link_to_delete(link_text, resource, confirmation = 'Are you sure?')
            if my_can? :destroy, resource
                snake = snake(resource.class)
                @controller_context.link_to(link_text, resource, id: "delete_#{snake}_#{resource.id}", data: { turbo_method: :delete, turbo_confirm: confirmation })
            else
                "<!-- delete link omitted -->"
            end
        end
    end

    end
end
