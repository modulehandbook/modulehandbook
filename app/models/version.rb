# frozen_string_literal: true

# this is an additional class accessing Papertrail's versions table.
# papertrail provides an extension point for 6.a. Custom Version Classes
# see
# https://github.com/paper-trail-gem/paper_trail#6a-custom-version-classes
# but this includes creating a special table for each versioned model.
# as long as this only reads, there should be no problem.

class Version < PaperTrail::Version
  belongs_to :author, class_name: "User",
                    foreign_key: "whodunnit"
end
