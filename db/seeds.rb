# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts 'seeding database'

users = [
  ['admin@mail.de', :admin],
  ['reader@mail.de', :reader],
  ['writer@mail.de', :writer],
  ['editor@mail.de', :editor],
  ['qa@mail.de', :qa]
]

defaultPW = ENV['SEED_USER_PW'] 
defaultPW ||= 'geheim12'
User.destroy_all
users.each do |u|
  user = User.create(email: u[0], password: defaultPW, password_confirmation: defaultPW, approved: true, confirmed_at: DateTime.now, role: u[1])
  puts "created User #{user.email} as #{user.role}"
end
user = User.create(email: 'unapproved@mail.de', password: defaultPW, password_confirmation: defaultPW, approved: false)
puts "created unapproved User #{user.email}"

# CourseProgram.destroy_all
# Program.destroy_all
# Course.destroy_all

imib = Program.create(name: 'Internationale Medieninformatik', code: 'IMI-B', degree: 'Bachelor', ects: 180)

# [1,"Nr","Modulbezeichnung                  ","Art","Form",","SWS","L",P
courses = [
  [1, 'B1', 'Informatik  1                     ', 'required', 'P  ', 'SL/Ü', '4/2', '6'],
  [1, 'B2', 'Computersysteme                   ', 'required', 'P  ', 'SL/Ü', '2/2', '5'],
  [1, 'B3', 'Propädeutikum und  Medientheorie  ', 'required', 'P  ', 'SL/Ü', '2/2', '5'],
  [1, 'B4', 'Mathematik  für Medieninformatik 1', 'required', 'P ', ' SL/Ü', '2/2', '5'],
  [1, 'B5', 'Grundlagen  der  Webprogrammierung', 'required', 'P  ', 'SL/Ü', '2/2', '5'],
  [1, 'B6', '1.  Fremdsprache         1        ', 'required', 'WP ', 'Ü   ', '4  ', '4'],
  [2, 'B7  ', ' Informatik 2                         ', 'required', ' P   ', ' SL/Ü ', ' 4/2 ', ' 5'],
  [2, 'B8  ', ' Grundlagen Digitaler Medien          ', 'required', ' P   ', ' SL/Ü ', ' 4/2 ', ' 6'],
  [2, 'B9  ', ' Netzwerke                            ', 'required', ' P   ', ' SL/Ü ', ' 2/1 ', ' 5'],
  [2, 'B10 ', ' Mathematik für    Medieninformatik 2', 'required', ' P   ', ' SL/Ü ', ' 2/1 ', ' 5'],
  [2, 'B11 ', ' Medienwirtschaft                     ', 'required', ' P   ', ' SL/Ü ', ' 4/1 ', ' 5'],
  [2, 'B12 ', ' 1.  Fremdsprache                     ', 'required', ' 2   ', ' WP   ', ' Ü   ', ' 4'],
  [3, 'B13 ', ' Bildverarbeitung                     ', 'required', ' P   ', ' SL/Ü ', ' 2/2 ', ' 5'],
  [3, 'B14 ', ' Datenbanken                          ', 'required', ' P   ', ' SL/Ü ', ' 2/2 ', ' 5'],
  [3, 'B15 ', ' Informatik 3                         ', 'required', ' P   ', ' SL/Ü ', ' 4/2 ', ' 6'],
  [3, 'B16 ', ' 2. Fremdsprache                      ', 'required', ' WP  ', ' Ü    ', ' 4   ', ' 4'],
  [3, 'B17 ', ' Computergrafik                       ', 'required', ' P   ', ' SL/Ü ', ' 2/2 ', ' 5'],
  [3, 'B18 ', ' 3D-Design                            ', 'required', ' P   ', ' Ü    ', ' 2   ', ' 5'],
  [4, 'B19   ', ' Internationale   Medienwirtschaft  und  Kommunikation ', 'required', ' P   ', ' SL/Ü ', ' 2/2 ', ' 5'],
  [4, 'B20   ', ' Praxisphase 1:  Fachpraktikum im  Ausland             ', 'required', ' P   ', '      ', '     ', ' 25'],
  [4, 'B20.1 ', ' Auswertung  von Erfahrungen am Praxisplatz            ', 'required', ' EL  ', ' Ü    ', ' 2   ', '  0'],
  [4, 'B20.2 ', ' Fachpraktikum                                         ', 'required', '     ', '      ', '     ', '   0'],
  [5, 'B21   ', ' Wahlpflichtmodul 1          ', 'required', ' WP  ', ' SL/Ü ', ' 2/2 ', ' 5'],
  [5, 'B22   ', ' Wahlpflichtmodul 2          ', 'required', ' WP  ', ' SL/Ü ', ' 2/2 ', ' 5'],
  [5, 'B23   ', ' Wahlpflichtmodul 3          ', 'required', ' WP  ', ' SL/Ü ', ' 2/2 ', ' 5'],
  [5, 'B24.1   ', ' Praxisphase 2:Praxisprojekt ', 'required', ' WP  ', ' 15   ', ' 1b  ', ' 15'],
  [5, 'B24.2 ', ' Projektmanagement           ', 'required', '     ', ' Ü    ', ' 2   ', ' 1b'],
  [6, 'B25 ', ' Wahlpflichtmodul 4 ', 'required', ' WP  ', ' SL/Ü ', ' 2/2 ', ' 5'],
  [6, 'B26 ', ' Wahlpflichtmodul 5 ', 'required', ' WP  ', ' SL/Ü ', ' 2/2 ', ' 5'],
  [6, 'B27 ', ' AWE:  Medienrecht             ', 'required', ' P   ', ' SL   ', ' 2   ', ' 2'],
  [6, 'B28 ', ' AWE  WP                       ', 'required', ' SL  ', '      ', ' 2   ', ' 2'],
  [6, 'B29 ', ' Bachelorarbeit                ', 'required', ' P   ', '      ', '     ', ' 12'],
  [6, 'B30 ', ' Bachelorseminar/Kolloquium    ', 'required', ' P   ', ' Ü    ', ' 1   ', ' 4'],
  [0, 'GTAT1 ', ' Game  Technology  &  Interactive  Systems  – Aktuelle  Themen  1 ', 'elective', 'SL/Ü', ' 2/2  ', ' 5'],
  [0, 'VCAT1 ', ' Visual  Computing  –  Aktuelle Themen 1                          ', 'elective', 'SL/Ü', ' 2/2  ', ' 5'],
  [0, 'WTAT1 ', ' Web Technology  –  Aktuelle Themen 1                             ', 'elective', 'SL/Ü', ' 2/2  ', ' 5'],
  [0, 'GT2   ', ' Game  Engines                                                    ', 'elective', 'SL/Ü', ' 2/2      ', ' 5'],
  [0, 'VC2   ', ' Bildanalyse                                                      ', 'elective', 'SL/Ü', ' 2/2      ', ' 5'],
  [0, 'WT2   ', ' Usability                                                        ', 'elective', 'SL/Ü', ' 2/2      ', ' 5'],
  [0, 'GTAT2 ', ' Game Technology & Interactive Systems – Aktuelle Themen 2        ', 'elective', 'SL/Ü', ' 2/2      ', ' 5'],
  [0, 'VCAT2 ', ' Visual  Computing – Aktuelle Themen 2                            ', 'elective', 'SL/Ü', ' 2/2      ', ' 5'],
  [0, 'WTAT2 ', ' Web  Technology – Aktuelle Themen2                               ', 'elective', 'SL/Ü', ' 2/2      ', ' 5']
]

courses.each do |a|
  puts "handling #{a}"

  c = Course.create(code: a[1].strip,
                    name: a[2].strip,
                    methods: "#{a[4].strip} #{a[5].strip}",
                    ects: a[6].strip.to_i)
  cp = CourseProgram.create(course: c, program: imib,
                            semester: a[0],
                            required: a[3].strip)
end
