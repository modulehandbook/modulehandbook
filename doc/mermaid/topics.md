```mermaid

sequenceDiagram


    programs#show->>+topic_description#new: create new topic: program_id
    topic_description#new->>+topic_description#create: post



```

```mermaid
classDiagram
    Course
    Program
    Topic o-- TopicDescription
    TopicDescription -- Course
    TopicDescription -- Program

    class TopicDescription{
      topic
      course_or_program
      description

    }
    class Topic{
      title
    }
    
```