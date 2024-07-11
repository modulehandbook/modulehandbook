flowchart TD
    
    
    MHF --http--> MH
    MH -- "html, css, json, docx" --> MHF
 
    MH -- json --> EX
    EX -- docx --> MH
    
    MH <-- SQL --> DB 

    subgraph all["Module Handbook Architecture"]
        subgraph front[Frontend]
        MHF("Browser\n(HTML, CSS)")
        end
        subgraph back["MH Backend: docker"]
        MH("Module Handbook\n(Rails App)")


        EX("Exporter\n(Javascript/Express App)")
        DB[("Database\n(Postgres)")]
        end

    
    end




    SPF --http--> SP
    SP -- "html, js" --> SPF
     

    
    SP <--  MongoDB Wire --> DBSP 
    subgraph studyplan["Studyplan Architecture"]
        subgraph frontsp[Frontend]
        SPF("Browser\n(Vue)")
        end
        subgraph backsp["Backend: docker"]
        SP("Study Plan\n(Express/Node App)")
       
        DBSP[("Database\n(Mongo)")]
        end
    
    end
   