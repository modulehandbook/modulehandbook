# frozen_string_literal: true

module ApplicationHelper
  require 'redcarpet'
  @@html_renderer = Redcarpet::Render::HTML.new
  @@markdown = Redcarpet::Markdown.new(@@html_renderer, {})

  def link_to_edit(link_text, resource)
    if can? :edit,resource
        path_helper = "edit_#{resource.class.to_s.downcase}_path"
        path = self.send(path_helper, resource)
        link_to(link_text, path)
    else
        "<!-- link omitted -->"
    end
  end
  
  def md2html(md)
    md = @@markdown.render(html_escape(md))
    raw("<div class = 'markdown'>#{md}</div>")
  end

  def generate_filename(program)
    code = program.try(:code)
    code = 'XX' if code.nil?
    name = program.try(:name) ? program.name.gsub(' ', '') : 'xxx'
    name = 'XX' if name.nil?
    "#{Time.zone.today}_#{to_clean_string(code)}-#{to_clean_string(name)}"
  end

  def to_clean_string(string)
    string.gsub(' ', '').to_s
  end

  def compare_course_codes(code1, code2)
    re = /(IMI25-)?([A-Z]+)(\d+)/
    letter_group = 2
    number_group = 3
    match1 = code1.match(re)
    match2 = code2.match(re)
    return -1 if match1.nil?
    return 1 if match2.nil?
    return -1 if match1[letter_group] < match2[letter_group]
    return 1 if match1[letter_group] > match2[letter_group]

    match1[number_group].to_i <=> match2[number_group].to_i
  end

  # def fetch_app_version
  #  env_file_path = Rails.root.join('.env')
  #  return 'unknown_version' unless File.exist?(env_file_path)
  #  env_file_contents = File.read(env_file_path)
  #  version_pattern = /TAG_MODULE_HANDBOOK=([^\s]*)/
  #  match = version_pattern.match(env_file_contents)
  #  match ? match[1] : 'unknown_version'
  # end
  # def fetch_instance_variable
  #  env_file_path = Rails.root.join('.env')
  #  return 'unknown' unless File.exist?(env_file_path)
  #  env_file_contents = File.read(env_file_path)
  #  version_pattern = /MODULE_HANDBOOK_INSTANCE=([\s\S]*)/
  #  match = version_pattern.match(env_file_contents)
  #  match ? match[1] : 'unknown'
  # end
end
