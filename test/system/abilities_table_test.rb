require 'application_system_test_case'

class AbilitiesTableTest < ApplicationSystemTestCase
  setup do
    @user = users(:one)
    system_test_login(@user.email, 'geheim12')
    # generate map in rails console (and replace Controller with according model):
    # c_a = ApplicationController.descendants.reject { |c| c.name.match("::") }.map{|c| [c, c.instance_methods(false)]}
    # c_a.each {|c, a| a.each {|b| puts "#{c} #{b}" }}
    @abilities_map = {
    Version => [:index],
    User => [:approve, :index, :user_params, :edit, :show, :set_user, :select_fields_index, :select_fields_single, :show_abilities, :destroy, :include_fields, :select_fields_edit, :update],
    Program => [:export_program_json, :import_courses_json, :index, :overview, :update, :import_program_json, :export_program_docx, :edit, :show, :create, :destroy, :new, :export_programs_json],
    Faculty => [:create, :index, :destroy, :edit, :show, :new, :update],
    Course => [:export_course_docx, :index, :change_state, :create_course_program_link, :edit, :show, :versions, :export_courses_json, :export_course_json, :revert_to, :create, :destroy, :import_course_json, :new, :update],
    CourseProgram => [:create, :index, :destroy, :edit, :show, :new, :update],
    Comment => [:create, :destroy, :edit, :show, :update]
    }

    visit abilities_url
  end

  test 'all_abilities_in_table' do
    @abilities_map.each do |model, methods|
      methods.each do |method|
        assert_selector "th", text: "#{model} / #{method}"
      end
    end
  end

  test 'smoke_test_ability_always_true' do
    row_header = "Version / index"
    column_header = "admin"

    column_index = find('table thead tr').all('th').map(&:text).index(column_header)
    row = find('table tbody').all('tr').find { |tr| tr.all('th,td').first.text == row_header }

    cell =  row.all('th,td')[column_index]

    assert_equal "true", cell.find('div').text
    assert_equal "rgb(212, 237, 218)", cell.find('div').native.style('background-color')
  end

  test 'smoke_test_ability_always_false' do
    row_header="User / set_user"
    column_header="reader"

    column_index = find('table thead tr').all('th').map(&:text).index(column_header)
    row = find('table tbody').all('tr').find { |tr| tr.all('th,td').first.text == row_header }

    cell =  row.all('th,td')[column_index]

    assert_equal "false", cell.find('div').text
    assert_equal "rgb(248, 215, 218)", cell.find('div').native.style('background-color')
  end
 end
