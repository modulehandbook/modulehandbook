
const fs = require('fs');
import {saveAs} from 'file-saver';


function export_docx(program_data) {
  // Create document
  const doc = new docx.Document();
  // Documents contain sections, you can have multiple sections per document, go here to learn more about sections
  // Example how to display page numbers
  // Import from 'docx' rather than '../build' if you install from npm
  const program_name_and_code = program_data.name + " [" + program_data.code + "]"

  // TODO: methoden auslagern, mit .addChildElement zusammenstöpseln!

  doc.addSection({
    headers: {
      default: new docx.Header({
        children: [
          new docx.Paragraph({
            children: [
              new docx.TextRun( "Module Descriptions GIU, " + program_name_and_code),
            ],
          }),
        ],
      }),
    },
    footers: {
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
    },
    properties: {
      pageNumberStart: 1,
      pageNumberFormatType: docx.PageNumberFormat.DECIMAL,
    },
    //
// ects: null
// mission: ""
    children: [
      new docx.Paragraph({
        text: program_data.name,
        heading: docx.HeadingLevel.HEADING_1,
      }),
      new docx.Paragraph({
        children: [new docx.TextRun("Code: " + program_data.code)],
      }),
      new docx.Paragraph({
        children: [new docx.TextRun("Degree: " + program_data.degree)],
      }),
      new docx.Paragraph({
        children: [new docx.TextRun("ECTS: " + program_data.ects)],
      }),
      new docx.Paragraph({
        children: [new docx.TextRun("Mission: " + program_data.mission), new docx.PageBreak()],
      }),
      new docx.Paragraph({
        children: [new docx.TextRun("Hello World 1"), new docx.PageBreak()],
      }),
      new docx.Paragraph({
        children: [new docx.TextRun("Hello World 2"), new docx.PageBreak()],
      }),
      new docx.Paragraph({
        children: [new docx.TextRun("Hello World 3"), new docx.PageBreak()],
      }),
      new docx.Paragraph({
        children: [new docx.TextRun("Hello World 4"), new docx.PageBreak()],
      }),
      new docx.Paragraph({
        children: [new docx.TextRun("Hello World 5"), new docx.PageBreak()],
      }),
    ],
  });

  // TODO: TypeError: doc.addTableOfContents is not a function
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
let program, course_programs;// courses;

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
