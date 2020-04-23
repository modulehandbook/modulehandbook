# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts 'seeding database'

# CourseProgram.destroy_all
# Program.destroy_all
# Course.destroy_all

imib = Program.create(name: 'Internationale Medieninformatik', code: 'IMI-B', degree: 'Bachelor', ects: 180)



#[1,"Nr","Modulbezeichnung                  ","Art","Form",","SWS","L",P
courses = [
[1,"B1","Informatik  1                     ","P  ","SL/Ü","4/2","6"],
[1,"B2","Computersysteme                   ","P  ","SL/Ü","2/2","5"],
[1,"B3","Propädeutikum und  Medientheorie  ","P  ","SL/Ü","2/2","5"],
[1,"B4","Mathematik  für Medieninformatik 1","P "," SL/Ü","2/2","5"],
[1,"B5","Grundlagen  der  Webprogrammierung","P  ","SL/Ü","2/2","5"],
[1,"B6","1.  Fremdsprache         1        ","WP ","Ü   ","4  ","4"],
[2,"B7  ", " Informatik 2                         ", " P   ", " SL/Ü ", " 4/2 ", " 5"],
[2,"B8  ", " Grundlagen Digitaler Medien          ", " P   ", " SL/Ü ", " 4/2 ", " 6"],
[2,"B9  ", " Netzwerke                            ", " P   ", " SL/Ü ", " 2/1 ", " 5"],
[2,"B10 ", " Mathematik für    Medieninformatik 2 ", " P   ", " SL/Ü ", " 2/1 ", " 5"],
[2,"B11 ", " Medienwirtschaft                     ", " P   ", " SL/Ü ", " 4/1 ", " 5"],
[2,",B12 ", " 1.  Fremdsprache                     ", " 2   ", " WP   ", " Ü   ", " 4"],
[3,"B13 ", " Bildverarbeitung                     ", " P   ", " SL/Ü ", " 2/2 ", " 5"],
[3,"B14 ", " Datenbanken                          ", " P   ", " SL/Ü ", " 2/2 ", " 5"],
[3,"B15 ", " Informatik 3                         ", " P   ", " SL/Ü ", " 4/2 ", " 6"],
[3,"B16 ", " 2. Fremdsprache                      ", " WP  ", " Ü    ", " 4   ", " 4"],
[3,"B17 ", " Computergrafik                       ", " P   ", " SL/Ü ", " 2/2 ", " 5"],
[3,"B18 ", " 3D-Design                            ", " P   ", " Ü    ", " 2   ", " 5"],
[4,"B19   ", " Internationale   Medienwirtschaft  und  Kommunikation ", " P   ", " SL/Ü ", " 2/2 ", " 5"],
[4,"B20   ", " Praxisphase 1:  Fachpraktikum im  Ausland             ", " P   ", "      ", "     ", " 25"],
[4,"B20.1 ", " Auswertung  von Erfahrungen am Praxisplatz            ", " EL  ", " Ü    ", " 2   ", "  0"],
[4,"B20.2 ", " Fachpraktikum                                         ", "     ", "      ", "     ", "   0"],
[5,"B21   ", " Wahlpflichtmodul 1          ", " WP  ", " SL/Ü ", " 2/2 ", " 5"],
[5,"B22   ", " Wahlpflichtmodul 2          ", " WP  ", " SL/Ü ", " 2/2 ", " 5"],
[5,"B23   ", " Wahlpflichtmodul 3          ", " WP  ", " SL/Ü ", " 2/2 ", " 5"],
[5,"B24.1   ", " Praxisphase 2:Praxisprojekt ", " WP  ", " 15   ", " 1b  ", " 15"],
[5,"B24.2 ", " Projektmanagement           ", "     ", " Ü    ", " 2   ", " 1b"],
[6,"B25 ", " Wahlpflichtmodul 4 ", " WP  ", " SL/Ü ", " 2/2 ", " 5"],
[6,"B26 ", " Wahlpflichtmodul 5 ", " WP  ", " SL/Ü ", " 2/2 ", " 5"],
[6,"B27 ", " AWE:  Medienrecht             ", " P   ", " SL   ", " 2   ", " 2"],
[6,"B28 ", " AWE  WP                       ", " SL  ", "      ", " 2   ", " 2"],
[6,"B29 ", " Bachelorarbeit                ", " P   ", "      ", "     ", " 12"],
[6,"B30 ", " Bachelorseminar/Kolloquium    ", " P   ", " Ü    ", " 1   ", " 4"],
[0,"GTAT1 ", " Game  Technology  &  Interactive  Systems  – Aktuelle  Themen  1 ", "elective","SL/Ü", " 2/2  ", " 5"],
[0,"VCAT1 ", " Visual  Computing  –  Aktuelle Themen 1                          ", "elective","SL/Ü", " 2/2  ", " 5"],
[0,"WTAT1 ", " Web Technology  –  Aktuelle Themen 1                             ", "elective","SL/Ü", " 2/2  ", " 5"],
[0,"GT2   ", " Game  Engines                                                    ", "elective","SL/Ü", " 2/2      ", " 5"],
[0,"VC2   ", " Bildanalyse                                                      ", "elective","SL/Ü", " 2/2      ", " 5"],
[0,"WT2   ", " Usability                                                        ", "elective","SL/Ü", " 2/2      ", " 5"],
[0,"GTAT2 ", " Game Technology & Interactive Systems – Aktuelle Themen 2        ", "elective","SL/Ü", " 2/2      ", " 5"],
[0,"VCAT2 ", " Visual  Computing – Aktuelle Themen 2                            ", "elective","SL/Ü", " 2/2      ", " 5"],
[0,"WTAT2 ", " Web  Technology – Aktuelle Themen2                               ", "elective","SL/Ü", " 2/2      ", " 5"]
]

courses.each do | a |
  puts "handling #{a}"

c = Course.create(code: a[1].strip,
  name: a[2].strip,
  methods: "#{a[4].strip} #{a[5].strip}",
  ects: a[6].strip.to_i)
cp = CourseProgram.create(course: c, program: imib,
  semester: a[0],
  required: a[3].strip )

end
