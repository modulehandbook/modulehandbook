// const docx = require('docx');
//import { Document, Packer, Paragraph, TextRun } from 'docx';
// import * as docx from "docx";
// import { saveAs } from 'FileSaver';
const fs = require('fs');
const { Document, Packer, Paragraph, TextRun } = require('docx');


function fetch_course(course_id) {
  $.get("courses/" + course_id + ".json", function(fetched_course) {
    return fetched_course;
    // console.log(fetched_course);
    // get courses of program
  });
}

function export_docx() {
  // Create document
  const doc = new Document();
  // Documents contain sections, you can have multiple sections per document, go here to learn more about sections
  // This simple example will only contain one section
  doc.addSection({
    properties: {},
    children: [
      new Paragraph({
        children: [
          new TextRun('Hello World'),
          new TextRun({
            text: 'Foo Bar',
            bold: true,
          }),
          new TextRun({
            text: '\tGithub is the best',
            bold: true,
          }),
        ],
      }),
    ],
  });
  // Used to export the file into a .docx file
  Packer.toBlob(doc).then((blob) => {
    // saveAs from FileSaver will download the file
    saveAs(blob, 'example.docx');
  });
  // Done!
}





// ---------------------------------------
let program, course_programs;

$(document).ready(function() {
  $('a#docx_export_link').on(
    'click',
    function(event) {
      var program_id = $(this).attr("data-id");
      // get the program
      $.get("programs/" + program_id + ".json", function(fetched_program) {
        program = fetched_program;
        // console.log(program);
        // get course-program-links
        $.get("course_programs.json", { program_id: program_id }, function(fetched_course_programs) {
          course_programs = fetched_course_programs;
          // course_programs.forEach((course_program, i) => {
          //   console.log(course_program);
          // });
          // get courses of program
        });
      })
      event.preventDefault();
      console.log("got data");
      export_docx();
    }
  );
});
