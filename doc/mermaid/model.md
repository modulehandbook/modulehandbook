# A Program has many Courses


```mermaid
classDiagram
    class Course{
      name
      code
      ects
      sws
      objectives
    }
    class Program{
      name
      code
      mission
      degree
      ects
    }
    Program o-- Course

```

# Programs and Courses are Linked...
... via CoursePrograms which stores semester and required (qualifies the association between course and program)
-> Courses can be part of many programs
```mermaid
classDiagram 
    
      class Program{
      name
      code
      mission
      degree
      ects
    }
    
    class Course{
      name
      code
      ects
      sws
      objectives
    }
  
    Program ~~ Course
     class CourseProgram{
        semester
        required
    }
    
    Program "1"--"*" CourseProgram
    Course "1"--"*" CourseProgram
   
   Program o-- Course
```




```
```mermaid
classDiagram 
    
    class Course{
      name
      code
      ects
      sws
      objectives
    }
    class Program{
      name
      code
      mission
      degree
      ects
    }
    Program *-- Course
```



classDiagram 
    
    class Course{
      name
      code
      ects
      sws
      objectives
    }
    class Program{
      name
      code
      mission
      degree
      ects
    }
    Program "*"--"*" Course

