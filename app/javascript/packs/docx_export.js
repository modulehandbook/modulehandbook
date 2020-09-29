
const fs = require('fs');
import {saveAs} from 'file-saver';


function export_docx(program_data) {
  // Create document
  const doc = new docx.Document();
  // Documents contain sections, you can have multiple sections per document, go here to learn more about sections
  // Example how to display page numbers
  // Import from 'docx' rather than '../build' if you install from npm
  const program_name_and_code = program_data.name + " [" + program_data.code + "]"

  const header = {
    default: new docx.Header({
      children: [
        new docx.Paragraph({
          children: [
            new docx.TextRun( "Module Descriptions GIU, " + program_name_and_code),
          ],
        }),
      ],
    }),
  };

  const footer = {
    default: new docx.Footer({
      children: [
        new docx.Paragraph({
          alignment: docx.AlignmentType.CENTER,
          children: [
            new docx.TextRun({
              children: ["Page ", docx.PageNumber.CURRENT],
            }),
            new docx.TextRun({
              children: [" of ", docx.PageNumber.TOTAL_PAGES],
            }),
          ],
        }),
      ],
    }),
  };

  const program_infos = [
    new docx.Paragraph({
      text: program_data.name,
      heading: docx.HeadingLevel.HEADING_1,
    }),
    new docx.Paragraph({
      text: "Program Infos",
      heading: docx.HeadingLevel.HEADING_2,
    }),
    new docx.Table({
      rows: [
        new docx.TableRow({
          children: [
            new docx.TableCell({
              children: [new docx.Paragraph("Code")],
            }),
            new docx.TableCell({
              children: [new docx.Paragraph(program_data.code === null ? '' : program_data.code)],
            }),
          ],
        }),

        new docx.TableRow({
          children: [
            new docx.TableCell({
              children: [new docx.Paragraph("Degree")],
            }),
            new docx.TableCell({
              children: [new docx.Paragraph(program_data.degree === null ? '' : program_data.degree)],
            }),
          ],
        }),

        new docx.TableRow({
          children: [
            new docx.TableCell({
              children: [new docx.Paragraph("ECTS")],
            }),
            new docx.TableCell({
              children: [new docx.Paragraph(program_data.ects === null ? '' : program_data.ects)],
            }),
          ],
        }),

        new docx.TableRow({
          children: [
            new docx.TableCell({
              children: [new docx.Paragraph("Mission")],
            }),
            new docx.TableCell({
              children: [new docx.Paragraph(program_data.mission === null ? '' : program_data.mission)],
            }),
          ],
        }),

      ],
    }),

    new docx.Paragraph({
      children: [new docx.PageBreak()],
    }),
  ];

  var course_infos = [
    new docx.Paragraph({
      text: "Course Descriptions",
      heading: docx.HeadingLevel.HEADING_2,
    }),
  ];
  const courses = program_data.courses;
  var i;
  for(i = 0; i < courses.length; i++) {
    var course = [
      new docx.Paragraph({
        text: courses[i].name,
        heading: docx.HeadingLevel.HEADING_3,
      }),
      new docx.Paragraph({
        text: 'A - Basic Information',
        heading: docx.HeadingLevel.HEADING_4,
      }),
      new docx.Table({
        rows: [
          new docx.TableRow({
            children: [
              new docx.TableCell({
                children: [new docx.Paragraph("Semester")],
              }),
              new docx.TableCell({
                children: [new docx.Paragraph(courses[i].semester === null ? '' : courses[i].semester)],
              }),
            ],
          }),

          new docx.TableRow({
            children: [
              new docx.TableCell({
                children: [new docx.Paragraph("Year")],
              }),
              new docx.TableCell({
                children: [new docx.Paragraph(courses[i].semester === null ? '' : courses[i].semester/2)],
              }),
            ],
          }),

          new docx.TableRow({
            children: [
              new docx.TableCell({
                children: [new docx.Paragraph("Code")],
              }),
              new docx.TableCell({
                children: [new docx.Paragraph(courses[i].code === null ? '' : courses[i].code)],
              }),
            ],
          }),

          new docx.TableRow({
            children: [
              new docx.TableCell({
                children: [new docx.Paragraph("Type")],
              }),
              new docx.TableCell({
                children: [new docx.Paragraph(courses[i].required === null ? '' : courses[i].required)],
              }),
            ],
          }),

          // new docx.TableRow({
          //   children: [
          //     new docx.TableCell({
          //       children: [new docx.Paragraph("Weekly contact hours")],
          //     }),
          //     new docx.TableCell({
          //       children: [new docx.Paragraph(courses[i].lectureHrs + ' hrs Lecture/Week, ' + courses[i].tutorialHrs + ' hrs Tutorial/Week, ' + courses[i].labHrs + ' hrs Lab/Week')],
          //     }),
          //   ],
          // }),

          new docx.TableRow({
            children: [
              new docx.TableCell({
                children: [new docx.Paragraph("ECTS")],
              }),
              new docx.TableCell({
                children: [new docx.Paragraph(courses[i].ects === null ? '' : courses[i].ects)],
              }),
            ],
          }),

          new docx.TableRow({
            children: [
              new docx.TableCell({
                children: [new docx.Paragraph("Prerequisites")],
              }),
              new docx.TableCell({
                children: [new docx.Paragraph(courses[i].prerequisites === null ? '' : courses[i].prerequisites)],
              }),
            ],
          }),

        ],
      }),



      new docx.Paragraph({
        text: 'B - Professional Information',
        heading: docx.HeadingLevel.HEADING_4,
      }),

      new docx.Table({
        rows: [
          new docx.TableRow({
            children: [
              new docx.TableCell({
                children: [new docx.Paragraph({
                  text: 'Aims',
                  heading: docx.HeadingLevel.HEADING_5,
                }),],
              }),
            ],
          }),
          new docx.TableRow({
            children: [
              new docx.TableCell({
                children: [new docx.Paragraph({
                  text: 'Mission',
                  heading: docx.HeadingLevel.HEADING_6,
                }),],
              }),
            ],
          }),
          new docx.TableRow({
            children: [
              new docx.TableCell({
                children: [new docx.Paragraph(courses[i].mission === null ? '' : courses[i].mission)],
              }),
            ],
          }),

          new docx.TableRow({
            children: [
              new docx.TableCell({
                children: [new docx.Paragraph({
                  text: 'Objectives',
                  heading: docx.HeadingLevel.HEADING_6,
                }),],
              }),
            ],
          }),
          new docx.TableRow({
            children: [
              new docx.TableCell({
                children: [new docx.Paragraph(courses[i].objectives === null ? '' : courses[i].objectives)],
              }),
            ],
          }),

          new docx.TableRow({
            children: [
              new docx.TableCell({
                children: [new docx.Paragraph({
                  text: 'Contents',
                  heading: docx.HeadingLevel.HEADING_6,
                }),],
              }),
            ],
          }),
          new docx.TableRow({
            children: [
              new docx.TableCell({
                children: [new docx.Paragraph(courses[i].contents === null ? '' : courses[i].contents)],
              }),
            ],
          }),


        ],
      }),


      new docx.Table({
        rows: [
          new docx.TableRow({
            children: [
              new docx.TableCell({
                children: [
                  new docx.Paragraph({
                    text: 'Intended Learning Outcomes',
                    heading: docx.HeadingLevel.HEADING_5,
                  }),
                  new docx.Paragraph('By the end of the course the student will have gained the following skills:'),
                ],
              }),
            ],
          }),
          new docx.TableRow({
            children: [
              new docx.TableCell({
                children: [new docx.Paragraph({
                  text: 'Knowledge and Understanding',
                  heading: docx.HeadingLevel.HEADING_6,
                }),],
              }),
            ],
          }),
          new docx.TableRow({
            children: [
              new docx.TableCell({
                children: [new docx.Paragraph(courses[i].skills_knowledge_understanding === null ? '' : courses[i].skills_knowledge_understanding)],
              }),
            ],
          }),

          new docx.TableRow({
            children: [
              new docx.TableCell({
                children: [new docx.Paragraph({
                  text: 'Intellectual Skills',
                  heading: docx.HeadingLevel.HEADING_6,
                }),],
              }),
            ],
          }),
          new docx.TableRow({
            children: [
              new docx.TableCell({
                children: [new docx.Paragraph(courses[i].skills_intellectual === null ? '' : courses[i].skills_intellectual)],
              }),
            ],
          }),

          new docx.TableRow({
            children: [
              new docx.TableCell({
                children: [new docx.Paragraph({
                  text: 'Professional and Practical Skills',
                  heading: docx.HeadingLevel.HEADING_6,
                }),],
              }),
            ],
          }),
          new docx.TableRow({
            children: [
              new docx.TableCell({
                children: [new docx.Paragraph(courses[i].skills_practical === null ? '' : courses[i].skills_practical)],
              }),
            ],
          }),

          new docx.TableRow({
            children: [
              new docx.TableCell({
                children: [new docx.Paragraph({
                  text: 'General and Transferrable Skills',
                  heading: docx.HeadingLevel.HEADING_6,
                }),],
              }),
            ],
          }),
          new docx.TableRow({
            children: [
              new docx.TableCell({
                children: [new docx.Paragraph(courses[i].skills_general === null ? '' : courses[i].skills_general)],
              }),
            ],
          }),


        ],
      }),

      new docx.Table({
        rows: [
          new docx.TableRow({
            children: [
              new docx.TableCell({
                children: [new docx.Paragraph({
                  text: 'Learning and Teaching Methods',
                  heading: docx.HeadingLevel.HEADING_5,
                }),],
              }),
            ],
          }),
          new docx.TableRow({
            children: [
              new docx.TableCell({
                children: [new docx.Paragraph(courses[i].methods === null ? '' : courses[i].methods)],
              }),
            ],
          }),

        ],
      }),

      new docx.Table({
        rows: [
          new docx.TableRow({
            children: [
              new docx.TableCell({
                children: [new docx.Paragraph({
                  text: 'Facilities required for teaching & learning',
                  heading: docx.HeadingLevel.HEADING_5,
                }),],
              }),
            ],
          }),
          new docx.TableRow({
            children: [
              new docx.TableCell({
                children: [new docx.Paragraph('Equipment - ')],// + courses[i].equipment === null ? '' : courses[i].equipment)],
              }),
            ],
          }),
          new docx.TableRow({
            children: [
              new docx.TableCell({
                children: [new docx.Paragraph('Rooms - ')],// + courses[i].room === null ? '' : courses[i].room)],
              }),
            ],
          }),

        ],
      }),

      new docx.Table({
        rows: [
          new docx.TableRow({
            children: [
              new docx.TableCell({
                children: [new docx.Paragraph({
                  text: 'Assessment',
                  heading: docx.HeadingLevel.HEADING_5,
                }),],
              }),
            ],
          }),
          new docx.TableRow({
            children: [
              new docx.TableCell({
                children: [new docx.Paragraph(courses[i].examination === null ? '' : courses[i].examination)],
              }),
            ],
          }),

        ],
      }),

      new docx.Table({
        rows: [
          new docx.TableRow({
            children: [
              new docx.TableCell({
                children: [new docx.Paragraph({
                  text: 'References',
                  heading: docx.HeadingLevel.HEADING_5,
                }),],
              }),
            ],
          }),
          new docx.TableRow({
            children: [
              new docx.TableCell({
                children: [new docx.Paragraph(courses[i].literature === null ? '' : courses[i].literature)],
              }),
            ],
          }),

        ],
      }),



      new docx.Paragraph({
        text: 'C - Administrative Information',
        heading: docx.HeadingLevel.HEADING_4,
      }),

      new docx.Table({
        rows: [
          new docx.TableRow({
            children: [
              new docx.TableCell({
                children: [new docx.Paragraph({
                  text: 'Course Coordinator Contact Information',
                  heading: docx.HeadingLevel.HEADING_5,
                }),],
              }),
            ],
          }),
          new docx.TableRow({
            children: [
              new docx.TableCell({
                children: [new docx.Paragraph('Course Coordinator - ')], // not yet in model
              }),
            ],
          }),
          new docx.TableRow({
            children: [
              new docx.TableCell({
                children: [new docx.Paragraph('E-mail - ')], // not yet in model
              }),
            ],
          }),
          new docx.TableRow({
            children: [
              new docx.TableCell({
                children: [new docx.Paragraph('Telephone - ')], // not yet in model
              }),
            ],
          }),
          new docx.TableRow({
            children: [
              new docx.TableCell({
                children: [new docx.Paragraph('Extension - ')], // not yet in model
              }),
            ],
          }),

        ],
      }),
    ];

    course_infos = course_infos.concat(course);
  }



  const contents = program_infos.concat(course_infos);

  // put elements of doc together
  doc.addSection({
    headers: header,
    footers: footer,
    properties: {
      pageNumberStart: 1,
      pageNumberFormatType: docx.PageNumberFormat.DECIMAL,
    },
    children: contents,
  });

  // TODO: TypeError: doc.addTableOfContents is not a function
  // add table of contents
  // const toc = new docx.TableOfContents("Modules", {
  //   hyperlink: true,
  //   headingStyleRange: "2-5",
  // });
  // console.log(doc);
  //
  // doc.addTableOfContents(toc);

  // Used to export the file into a .docx file
  docx.Packer.toBlob(doc).then((blob) => {
    const code = program_data.code ? program_data.code.split(' ').join('') : 'XX'
    const name = program_data.code ? program_data.name.split(' ').join('') : 'xxx'
    const date_today = new Date().toJSON().slice(0,10);
    const filename = date_today + '_' + code + '-' + name + '.docx'
    // saveAs from FileSaver will download the file
    saveAs(blob, filename);
  });
  // Done!
}



// ---------------------------------------

$(document).on('turbolinks:load', function() {
  $('a#docx_export_link').on(
    'click',
    function(event) {
      var program_id = $(this).attr("data-id");
      // get the program
      $.get("programs/" + program_id + ".json", function(data) {
        console.log(data);
        export_docx(data);
      });
    }
  )
});
