---

title: "ECMA-367: Eiffel — Analysis, Design and Programming Language"

edition: "2nd Edition"

date: "June 2006"

iso\_equivalent: "ISO/IEC 25436"

publisher: "Ecma International"

tags: \[eiffel, language-spec, ecma-367, iso-25436, programming-languages]

------

title: "ECMA-367: Eiffel — Analysis, Design and Programming Language"

edition: "2nd Edition"

date: "June 2006"

iso\_equivalent: "ISO/IEC 25436"

publisher: "Ecma International"

tags: \[eiffel, language-spec, ecma-367, iso-25436, programming-languages]

---



\# ECMA-367  

\## Eiffel: Analysis, Design and Programming Language  

\### 2nd Edition — June 2006



Source: ECMA International Standard ECMA-367 (Second Edition, 2006) :contentReference\[oaicite:0]{index=0}



---



\## Document Metadata



\- \*\*Standard Number:\*\* ECMA-367  

\- \*\*Edition:\*\* Second Edition  

\- \*\*Date:\*\* June 2006  

\- \*\*ISO Equivalent:\*\* ISO/IEC 25436  

\- \*\*Editor:\*\* Bertrand Meyer  

\- \*\*Convener:\*\* Emmanuel Stapf  

\- \*\*Technical Group:\*\* TC39-TG4 (Eiffel)



This edition introduces no major change of substance compared to the First Edition but clarifies and corrects several semantic and definitional issues arising from implementation feedback and practical use. :contentReference\[oaicite:1]{index=1}



---



\# Brief History



Eiffel was originally designed in 1985 as both a \*method of software construction\* and a \*notation supporting that method\*.  

The first commercial implementation was released in 1986. The principal designer was \*\*Bertrand Meyer\*\*, with major contributions from \*\*Jean-Marc Nerson\*\* and others.



By 2002, Ecma International created \*\*Technical Group 4 (TC39-TG4)\*\* to formalize Eiffel as an international standard.  

This Second Edition was completed in April 2006 and later approved as \*\*ISO/IEC 25436\*\*. :contentReference\[oaicite:2]{index=2}



---



\# Table of Contents



(Full structure preserved for Obsidian navigation)



1\. Scope  

2\. Conformance  

3\. Normative References  

4\. Definitions  

5\. Notational Conventions  

6\. Acronyms and Abbreviations  

7\. General Description  

8\. Language Specification  

9\. Index  



---



\# 1. Scope



\## 1.1 Overview



This document provides the \*\*full reference for the Eiffel language\*\*.



Eiffel is both:

\- A method of software construction  

\- A programming language for analysis, design, implementation, and maintenance of software systems  



In this document, \*\*“Eiffel”\*\* refers specifically to the \*Eiffel programming language\*. :contentReference\[oaicite:3]{index=3}



---



\## 1.2 “The Standard”



The official language definition – \*\*“the Standard”\*\* – is contained in \*\*Partition 8\*\*, except for portions marked:



> Informative text  

> End



Such sections are explanatory and not normative. :contentReference\[oaicite:4]{index=4}



---



\## 1.3 Aspects Covered



The Standard specifies:



\- The lexical structure of Eiffel texts  

\- The syntactic structure of Eiffel texts  

\- Validity constraints on syntactically legal programs  

\- The semantic effect of valid Eiffel programs  

\- Requirements for conforming Eiffel implementations  



---



\## 1.4 Aspects Not Covered



The Standard \*\*does not specify\*\*:



\- Requirements of a computing environment for Eiffel execution  

\- Behavior if system limits are exceeded  

\- Translation mechanisms for Eiffel  

\- Runtime startup mechanisms  

\- User interaction and tooling mechanisms  



---



\# 2. Conformance



\## 2.1 Definition of Conformance



An Eiffel implementation is \*\*conformant if and only if\*\*, in its default mode, it:



1\. Accepts and correctly executes programs that satisfy \*\*all syntax, validity, and semantic rules\*\*.  

2\. Rejects any program that violates \*\*any lexical, syntactical, or validity rule\*\*.  

3\. Does \*\*not perform semantic processing\*\* on invalid texts. :contentReference\[oaicite:5]{index=5}



---



\## 2.2 Compatibility and Non-Default Options



Implementations may provide non-default modes for backward compatibility, but:



\- They must not be default.

\- They must be clearly documented as \*\*non-conformant\*\*.



---



\## 2.3 Departure from the Standard



If an implementation is not fully conformant, documentation must:



\- Declare non-conformance  

\- List known deviations  

\- Provide a roadmap for compliance  



---



\# 3. Normative References



\## 3.1 Earlier Eiffel Specifications



\- Bertrand Meyer — \*Eiffel: The Language\* (1991/1992)  

\- Bertrand Meyer — \*Standard Eiffel\* (ongoing)  

\- Bertrand Meyer — \*Object-Oriented Software Construction\* (1988, 1997)



---



\## 3.2 Eiffel Kernel Library (ELKS)



The Standard assumes support for core classes:



\- `ANY`, `NONE`, `TYPE`, `DISPOSABLE`, `TYPED\_POINTER`

\- Basic types: `INTEGER`, `BOOLEAN`, `REAL`, `STRING`, `CHARACTER`, etc.

\- Core structures: `ARRAY`, `TUPLE`

\- Agents: `FUNCTION`, `PROCEDURE`, `ROUTINE`

\- Exceptions: `EXCEPTION`, `ASSERTION\_VIOLATION`, etc.



---



\# 4. Definitions



All Eiffel technical terms are formally defined in sections labeled:



> \*\*Definition\*\*



Each defined term appears \*\*bolded on its first occurrence.\*\*



---



\# 5. Notational Conventions



\## 5.1 Standard Element Types



Each clause belongs to one of these categories:



\- \*\*Syntax\*\*

\- \*\*Validity\*\*

\- \*\*Semantics\*\*

\- \*\*Definition\*\*

\- \*\*Principle\*\*



Clauses without label are considered \*\*Definitions\*\*.



---



\## 5.2 Normative Elements



Only \*\*syntax, validity, and semantic\*\* rules define conformance.



Principles are explanatory but describe consequences of formal rules. :contentReference\[oaicite:6]{index=6}



---



\## 5.3 Use of Defined Terms



Defined technical terms appear \*\*underlined in the original document\*\* when first used formally in a clause.



In this Markdown version:

\- I preserve them using \*\*bold + inline code\*\*, like: \*\*`introduce`\*\*  

\- Conceptual uses remain unstyled for clarity.



---



\## 5.4 Unfolded Forms



Certain language constructs are defined through \*\*unfolded forms\*\*, reducing complex constructs to simpler ones.  

Example: An anchored type `like a` has a \*deanchored form\*, defined as the type of `a`.



---



\## 5.5 “If and Only If” Validity Rule Style



Validation rules are expressed as:



> A construct is valid \*\*if and only if\*\* conditions X, Y, Z hold.



This makes validity rules both \*\*necessary and sufficient\*\*.



---



\# 6. Acronyms and Abbreviations



\## 6.1 Name of the Language

The name \*\*Eiffel\*\* is not an acronym.  

Capital E, rest lowercase.



\## 6.2 Pronunciation



\- English: stress on first syllable  

\- French: stress on second syllable  

\- Other languages: closest approximation



---



\# 7. General Description (Informative)



\## 7.1 Design Principles



Eiffel emphasizes:



\- \*\*Reusability\*\*

\- \*\*Extendibility\*\*

\- \*\*Reliability\*\*

\- \*\*Efficiency\*\*

\- \*\*Portability\*\*

\- \*\*Openness\*\*



Reliability is achieved through:

\- Static typing  

\- Assertions  

\- Disciplined exception handling  

\- Automatic garbage collection :contentReference\[oaicite:7]{index=7}



---



\## 7.2 Object-Oriented Design



Eiffel follows classic object-oriented principles:



\- Program = structured collection of \*\*classes\*\*

\- Objects = instances of abstract data types

\- Relations between classes:

&nbsp; - Client relation

&nbsp; - Inheritance relation  



Formal definition:



> Object-oriented design is the construction of software systems as structured collections of abstract data type implementations.



---



\## 7.3 Classes (Introductory Overview)



A \*\*class\*\* defines:

\- A set of run-time objects  

\- The features (operations, attributes) applicable to them  



Classes exist at \*\*compile time\*\*.  

Objects exist at \*\*run time\*\*.



Example presented in the standard:



```eiffel

class ACCOUNT



feature

&nbsp;   balance: INTEGER

&nbsp;   owner: PERSON



&nbsp;   deposit (sum: INTEGER)

&nbsp;       do

&nbsp;           balance := balance + sum

&nbsp;       end



&nbsp;   may\_withdraw (sum: INTEGER): BOOLEAN

&nbsp;       do

&nbsp;           Result := (balance >= sum)

&nbsp;       end

end





\# ECMA-367  

\## Eiffel: Analysis, Design and Programming Language  

\### 2nd Edition — June 2006



Source: ECMA International Standard ECMA-367 (Second Edition, 2006) :contentReference\[oaicite:0]{index=0}



---



\## Document Metadata



\- \*\*Standard Number:\*\* ECMA-367  

\- \*\*Edition:\*\* Second Edition  

\- \*\*Date:\*\* June 2006  

\- \*\*ISO Equivalent:\*\* ISO/IEC 25436  

\- \*\*Editor:\*\* Bertrand Meyer  

\- \*\*Convener:\*\* Emmanuel Stapf  

\- \*\*Technical Group:\*\* TC39-TG4 (Eiffel)



This edition introduces no major change of substance compared to the First Edition but clarifies and corrects several semantic and definitional issues arising from implementation feedback and practical use. :contentReference\[oaicite:1]{index=1}



---



\# Brief History



Eiffel was originally designed in 1985 as both a \*method of software construction\* and a \*notation supporting that method\*.  

The first commercial implementation was released in 1986. The principal designer was \*\*Bertrand Meyer\*\*, with major contributions from \*\*Jean-Marc Nerson\*\* and others.



By 2002, Ecma International created \*\*Technical Group 4 (TC39-TG4)\*\* to formalize Eiffel as an international standard.  

This Second Edition was completed in April 2006 and later approved as \*\*ISO/IEC 25436\*\*. :contentReference\[oaicite:2]{index=2}



---



\# Table of Contents



(Full structure preserved for Obsidian navigation)



1\. Scope  

2\. Conformance  

3\. Normative References  

4\. Definitions  

5\. Notational Conventions  

6\. Acronyms and Abbreviations  

7\. General Description  

8\. Language Specification  

9\. Index  



---



\# 1. Scope



\## 1.1 Overview



This document provides the \*\*full reference for the Eiffel language\*\*.



Eiffel is both:

\- A method of software construction  

\- A programming language for analysis, design, implementation, and maintenance of software systems  



In this document, \*\*“Eiffel”\*\* refers specifically to the \*Eiffel programming language\*. :contentReference\[oaicite:3]{index=3}



---



\## 1.2 “The Standard”



The official language definition – \*\*“the Standard”\*\* – is contained in \*\*Partition 8\*\*, except for portions marked:



> Informative text  

> End



Such sections are explanatory and not normative. :contentReference\[oaicite:4]{index=4}



---



\## 1.3 Aspects Covered



The Standard specifies:



\- The lexical structure of Eiffel texts  

\- The syntactic structure of Eiffel texts  

\- Validity constraints on syntactically legal programs  

\- The semantic effect of valid Eiffel programs  

\- Requirements for conforming Eiffel implementations  



---



\## 1.4 Aspects Not Covered



The Standard \*\*does not specify\*\*:



\- Requirements of a computing environment for Eiffel execution  

\- Behavior if system limits are exceeded  

\- Translation mechanisms for Eiffel  

\- Runtime startup mechanisms  

\- User interaction and tooling mechanisms  



---



\# 2. Conformance



\## 2.1 Definition of Conformance



An Eiffel implementation is \*\*conformant if and only if\*\*, in its default mode, it:



1\. Accepts and correctly executes programs that satisfy \*\*all syntax, validity, and semantic rules\*\*.  

2\. Rejects any program that violates \*\*any lexical, syntactical, or validity rule\*\*.  

3\. Does \*\*not perform semantic processing\*\* on invalid texts. :contentReference\[oaicite:5]{index=5}



---



\## 2.2 Compatibility and Non-Default Options



Implementations may provide non-default modes for backward compatibility, but:



\- They must not be default.

\- They must be clearly documented as \*\*non-conformant\*\*.



---



\## 2.3 Departure from the Standard



If an implementation is not fully conformant, documentation must:



\- Declare non-conformance  

\- List known deviations  

\- Provide a roadmap for compliance  



---



\# 3. Normative References



\## 3.1 Earlier Eiffel Specifications



\- Bertrand Meyer — \*Eiffel: The Language\* (1991/1992)  

\- Bertrand Meyer — \*Standard Eiffel\* (ongoing)  

\- Bertrand Meyer — \*Object-Oriented Software Construction\* (1988, 1997)



---



\## 3.2 Eiffel Kernel Library (ELKS)



The Standard assumes support for core classes:



\- `ANY`, `NONE`, `TYPE`, `DISPOSABLE`, `TYPED\_POINTER`

\- Basic types: `INTEGER`, `BOOLEAN`, `REAL`, `STRING`, `CHARACTER`, etc.

\- Core structures: `ARRAY`, `TUPLE`

\- Agents: `FUNCTION`, `PROCEDURE`, `ROUTINE`

\- Exceptions: `EXCEPTION`, `ASSERTION\_VIOLATION`, etc.



---



\# 4. Definitions



All Eiffel technical terms are formally defined in sections labeled:



> \*\*Definition\*\*



Each defined term appears \*\*bolded on its first occurrence.\*\*



---



\# 5. Notational Conventions



\## 5.1 Standard Element Types



Each clause belongs to one of these categories:



\- \*\*Syntax\*\*

\- \*\*Validity\*\*

\- \*\*Semantics\*\*

\- \*\*Definition\*\*

\- \*\*Principle\*\*



Clauses without label are considered \*\*Definitions\*\*.



---



\## 5.2 Normative Elements



Only \*\*syntax, validity, and semantic\*\* rules define conformance.



Principles are explanatory but describe consequences of formal rules. :contentReference\[oaicite:6]{index=6}



---



\## 5.3 Use of Defined Terms



Defined technical terms appear \*\*underlined in the original document\*\* when first used formally in a clause.



In this Markdown version:

\- I preserve them using \*\*bold + inline code\*\*, like: \*\*`introduce`\*\*  

\- Conceptual uses remain unstyled for clarity.



---



\## 5.4 Unfolded Forms



Certain language constructs are defined through \*\*unfolded forms\*\*, reducing complex constructs to simpler ones.  

Example: An anchored type `like a` has a \*deanchored form\*, defined as the type of `a`.



---



\## 5.5 “If and Only If” Validity Rule Style



Validation rules are expressed as:



> A construct is valid \*\*if and only if\*\* conditions X, Y, Z hold.



This makes validity rules both \*\*necessary and sufficient\*\*.



---



\# 6. Acronyms and Abbreviations



\## 6.1 Name of the Language

The name \*\*Eiffel\*\* is not an acronym.  

Capital E, rest lowercase.



\## 6.2 Pronunciation



\- English: stress on first syllable  

\- French: stress on second syllable  

\- Other languages: closest approximation



---



\# 7. General Description (Informative)



\## 7.1 Design Principles



Eiffel emphasizes:



\- \*\*Reusability\*\*

\- \*\*Extendibility\*\*

\- \*\*Reliability\*\*

\- \*\*Efficiency\*\*

\- \*\*Portability\*\*

\- \*\*Openness\*\*



Reliability is achieved through:

\- Static typing  

\- Assertions  

\- Disciplined exception handling  

\- Automatic garbage collection :contentReference\[oaicite:7]{index=7}



---



\## 7.2 Object-Oriented Design



Eiffel follows classic object-oriented principles:



\- Program = structured collection of \*\*classes\*\*

\- Objects = instances of abstract data types

\- Relations between classes:

&nbsp; - Client relation

&nbsp; - Inheritance relation  



Formal definition:



> Object-oriented design is the construction of software systems as structured collections of abstract data type implementations.



---



\## 7.3 Classes (Introductory Overview)



A \*\*class\*\* defines:

\- A set of run-time objects  

\- The features (operations, attributes) applicable to them  



Classes exist at \*\*compile time\*\*.  

Objects exist at \*\*run time\*\*.



Example presented in the standard:



```eiffel

class ACCOUNT



feature

&nbsp;   balance: INTEGER

&nbsp;   owner: PERSON



&nbsp;   deposit (sum: INTEGER)

&nbsp;       do

&nbsp;           balance := balance + sum

&nbsp;       end



&nbsp;   may\_withdraw (sum: INTEGER): BOOLEAN

&nbsp;       do

&nbsp;           Result := (balance >= sum)

&nbsp;       end

end



