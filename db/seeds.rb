# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies)

Rails.logger.debug 'seeding database'

users = [
  ['admin@mail.de', :admin],
  ['reader@mail.de', :reader],
  ['writer@mail.de', :writer],
  ['editor@mail.de', :editor],
  ['qa@mail.de', :qa]
]

defaultPW = ENV.fetch('SEED_USER_PW', nil)
defaultPW ||= 'geheim12'
User.destroy_all
users.each do |u|
  user = User.create(email: u[0], password: defaultPW, password_confirmation: defaultPW, approved: true,
                     confirmed_at: DateTime.now, role: u[1])
  Rails.logger.debug { "created User #{user.email} as #{user.role}" }
end
user = User.create(email: 'unapproved@mail.de', password: defaultPW, password_confirmation: defaultPW, approved: false)
Rails.logger.debug { "created unapproved User #{user.email}" }

Program.destroy_all
Course.destroy_all

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
  [4, 'B19   ', ' Internationale   Medienwirtschaft  und  Kommunikation ', 'required', ' P   ', ' SL/Ü ', ' 2/2 ',
   ' 5'],
  [4, 'B20   ', ' Praxisphase 1:  Fachpraktikum im  Ausland             ', 'required', ' P   ', '      ', '     ',
   ' 25'],
  [4, 'B20.1 ', ' Auswertung  von Erfahrungen am Praxisplatz            ', 'required', ' EL  ', ' Ü    ', ' 2   ',
   '  0'],
  [4, 'B20.2 ', ' Fachpraktikum                                         ', 'required', '     ', '      ', '     ',
   '   0'],
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
  [0, 'GTAT1 ', ' Game  Technology  &  Interactive  Systems  – Aktuelle  Themen  1 ', 'elective', 'SL/Ü', ' 2/2  ',
   ' 5'],
  [0, 'VCAT1 ', ' Visual  Computing  –  Aktuelle Themen 1                          ', 'elective', 'SL/Ü', ' 2/2  ',
   ' 5'],
  [0, 'WTAT1 ', ' Web Technology  –  Aktuelle Themen 1                             ', 'elective', 'SL/Ü', ' 2/2  ',
   ' 5'],
  [0, 'GT2   ', ' Game  Engines                                                    ', 'elective', 'SL/Ü', ' 2/2      ',
   ' 5'],
  [0, 'VC2   ', ' Bildanalyse                                                      ', 'elective', 'SL/Ü', ' 2/2      ',
   ' 5'],
  [0, 'WT2   ', ' Usability                                                        ', 'elective', 'SL/Ü', ' 2/2      ',
   ' 5'],
  [0, 'GTAT2 ', ' Game Technology & Interactive Systems – Aktuelle Themen 2        ', 'elective', 'SL/Ü', ' 2/2      ',
   ' 5'],
  [0, 'VCAT2 ', ' Visual  Computing – Aktuelle Themen 2                            ', 'elective', 'SL/Ü', ' 2/2      ',
   ' 5'],
  [0, 'WTAT2 ', ' Web  Technology – Aktuelle Themen2                               ', 'elective', 'SL/Ü', ' 2/2      ',
   ' 5']
]

courses.each do |a|
  Rails.logger.debug { "handling #{a}" }

  c = Course.create(code: a[1].strip,
                    name: a[2].strip,
                    methods: "#{a[4].strip} #{a[5].strip}",
                    ects: a[6].strip.to_i)
  CourseProgram.create(course: c, program: imib,
                       semester: a[0],
                       required: a[3].strip)
end

# add some versions
Version.destroy_all

writer = User.find_by(email: 'writer@mail.de')
Rails.logger.debug writer.inspect
PaperTrail.request.whodunnit = writer.id

b7 = Course.find_by(code: 'B7')
b27 = Course.find_by(code: 'B27')
wt2 = Course.find_by(code: 'WT2')

b7.update contents: 'first'
b7.update contents: 'second'
b7.update contents: 'third'

wt2.update contents: 'first'
wt2.update contents: 'second'
wt2.update contents: 'third'

editor = User.find_by(email: 'editor@mail.de')
PaperTrail.request.whodunnit = editor.id

b27.update contents: 'first'
b27.update contents: 'second'
b27.update contents: 'third'

Topic.destroy_all
TopicDescription.destroy_all

imib_copy = imib.create_copy
imib_copy.save!

topic1 = Topic.create(title: "Wissenschaftliches Arbeiten")
topic2 = Topic.create(title: "Programmierhandwerk")
topic3 = Topic.create(title: "Thema nur in Original")
TopicDescription.create(description: "Beschreibung für Wissenschaftliches Arbeiten in imib", topic: topic1, implementable: imib)
TopicDescription.create(description: "Beschreibung für Wissenschaftliches Arbeiten in imib copy",  topic: topic1, implementable: imib_copy)

TopicDescription.create(description: "Beschreibung für Programmierhandwerk in imib", topic: topic2, implementable: imib)
TopicDescription.create(description: "Beschreibung für Programmierhandwerk in imib copy", topic: topic2, implementable: imib_copy)

TopicDescription.create(description: "Beschreibung für Thema3", topic: topic3, implementable: imib)

info1 = Course.find_by(code: 'B1')
info3 = Course.find_by(code: 'B15')

TopicDescription.create(description: "git", topic: topic2, implementable: info3)
TopicDescription.create(description: "componentenauswahl", topic: topic1, implementable: info3)
TopicDescription.create(description: "debugger", topic: topic2, implementable: info1)
TopicDescription.create(description: "lab reports", topic: topic1, implementable: info1)
TopicDescription.create(description: "thema3 in info3", topic: topic3, implementable: info3)





