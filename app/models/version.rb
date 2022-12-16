class Version < PaperTrail::Version
  belongs_to :creator, class_name: "User",
                    foreign_key: "whodunnit"
end
