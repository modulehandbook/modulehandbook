class Version < PaperTrail::Version
  belongs_to :author, class_name: "User",
                    foreign_key: "whodunnit"
end
