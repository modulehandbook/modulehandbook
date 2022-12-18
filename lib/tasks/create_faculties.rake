
namespace :db do
  desc "Creates GIU Faculties"
  task :create_faculties => :environment do
    Faculty.create(name: "Faculty of Engineering", url: "https://giu-uni.de/en/academic-specializations/engineering/")
    Faculty.create(name: "Faculty of Informatics and Computer Science", url: "https://giu-uni.de/en/academic-specializations/informatics/")
    Faculty.create(name: "Faculty of Business Administration", url: "https://giu-uni.de/en/academic-specializations/business-administration/")
    Faculty.create(name: "Faculty of Design", url: "https://giu-uni.de/en/academic-specializations/design/")
    Faculty.create(name: "Faculty of Architectural Engineering", url: "https://giu-uni.de/en/academic-specializations/architectural-engineering/")
    Faculty.create(name: "Faculty of Biotechnology", url: "https://giu-uni.de/en/academic-specializations/biotechnology/")
    Faculty.create(name: "Pharmaceutical Engineering and Technology", url: "https://giu-uni.de/en/academic-specializations/pharmaceutical-engineering-program/")
  end
end
