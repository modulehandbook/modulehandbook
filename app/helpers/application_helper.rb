module ApplicationHelper
  require 'redcarpet'
  @@html_renderer = Redcarpet::Render::HTML.new
  @@markdown = Redcarpet::Markdown.new(@@html_renderer, extensions = {})

  def md2html(md)
    md = @@markdown.render(html_escape(md))
    raw("<div class = 'markdown'>#{md}</div>'")
  end

  def generate_filename(program)
    code = program.try(:code)
    code = 'XX' if code.nil?
    name = program.try(:name) ? program.name.gsub(' ', '') : 'xxx'
    name = 'XX' if name.nil?
    Date.today.to_s + '_' + to_clean_string(code) + '-' + to_clean_string(name)
  end

  def to_clean_string(string)
    string.gsub(' ', '').to_s
  end
end
