module ApplicationHelper
  require 'redcarpet'
  @@html_renderer = Redcarpet::Render::HTML.new
  @@markdown = Redcarpet::Markdown.new(@@html_renderer, extensions = {})

  def md2html(md)
    raw(@@markdown.render(html_escape(md)))
  end
end
