'From Cuis 4.2 of 25 July 2013 [latest update: #2533] on 10 August 2015 at 6:02:26.2939 pm'!
'Description Contains abstract classes RecordLayout and Field which are useful for defining fixed-length data records of the type often required by legacy data systems.'!
!provides: 'Records' 1 14!
!classDefinition: #CompileFields category: #'Records-Model'!
Object subclass: #CompileFields
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Records-Model'!
!classDefinition: 'CompileFields class' category: #'Records-Model'!
CompileFields class
	instanceVariableNames: ''!

!classDefinition: #ExampleGroup category: #'Records-Model'!
Object subclass: #ExampleGroup
	instanceVariableNames: 'seq payeesSub payeesTotal paidSub paidTotal payerTotal'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Records-Model'!
!classDefinition: 'ExampleGroup class' category: #'Records-Model'!
ExampleGroup class
	instanceVariableNames: ''!

!classDefinition: #Field category: #'Records-Model'!
Object subclass: #Field
	instanceVariableNames: 'location pad left'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Records-Model'!
!classDefinition: 'Field class' category: #'Records-Model'!
Field class
	instanceVariableNames: ''!

!classDefinition: #RecordLayout category: #'Records-Model'!
Object subclass: #RecordLayout
	instanceVariableNames: 'data'
	classVariableNames: 'Handler'
	poolDictionaries: ''
	category: 'Records-Model'!
!classDefinition: 'RecordLayout class' category: #'Records-Model'!
RecordLayout class
	instanceVariableNames: ''!

!classDefinition: #ExampleLayout category: #'Records-Model'!
RecordLayout subclass: #ExampleLayout
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Records-Model'!
!classDefinition: 'ExampleLayout class' category: #'Records-Model'!
ExampleLayout class
	instanceVariableNames: ''!

!classDefinition: #ExampleRecord1 category: #'Records-Model'!
ExampleLayout subclass: #ExampleRecord1
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Records-Model'!
!classDefinition: 'ExampleRecord1 class' category: #'Records-Model'!
ExampleRecord1 class
	instanceVariableNames: ''!

!classDefinition: #ExampleRecord2 category: #'Records-Model'!
ExampleLayout subclass: #ExampleRecord2
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Records-Model'!
!classDefinition: 'ExampleRecord2 class' category: #'Records-Model'!
ExampleRecord2 class
	instanceVariableNames: ''!

!classDefinition: #ExampleRecord3 category: #'Records-Model'!
ExampleLayout subclass: #ExampleRecord3
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Records-Model'!
!classDefinition: 'ExampleRecord3 class' category: #'Records-Model'!
ExampleRecord3 class
	instanceVariableNames: ''!

!classDefinition: #AbutmentTests category: #'Records-Tests'!
TestCase subclass: #AbutmentTests
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Records-Tests'!
!classDefinition: 'AbutmentTests class' category: #'Records-Tests'!
AbutmentTests class
	instanceVariableNames: ''!

!classDefinition: #SizeTests category: #'Records-Tests'!
TestCase subclass: #SizeTests
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Records-Tests'!
!classDefinition: 'SizeTests class' category: #'Records-Tests'!
SizeTests class
	instanceVariableNames: ''!


!ExampleGroup commentStamp: 'dhn 6/8/2015 15:59' prior: 0!
ExampleGroup gathers information and distributes it among the records of a set. It demonstrates the use of the RecordLayout and Field classes. To run the program, do (cmd-d) the following:

	ExampleGroup makeFile.
!

!Field commentStamp: 'dhn 1/17/2015 17:21' prior: 0!
A Field is a container for the location, size, justification, and padding of a field in a data record.
!

!RecordLayout commentStamp: 'dhn 6/8/2015 15:53' prior: 0!
RecordLayout is an abstract class used to form data records such as those which might be written to a file. For more information, do (cmd-d) the following:

	RecordLayout how.!

!ExampleLayout commentStamp: '<historical>' prior: 0!
ExampleLayout is used to set selected data fields in the records of ExampleGroup. Some of the information may span records.!

!CompileFields class methodsFor: 'compiling' stamp: 'dhn 8/10/2015 13:07'!
from: array2 for: aClass
	"Create a #fields class method in aClass class with fields defined in array2, an array of arrays"
"
	CompileFields from: #(
		#(#date    10)
		#(#blank    1)
		#(#name 14)
	) for: Test.
"
	| str |
	str _ String new writeStream.
	str 
		nextPutAll: 'fields'; newLine;
		nextPutAll: '	"Answer the record definition consisting of field names and positions"'; newLine;
		nextPutAll: '	^ Dictionary new'; newLine;
		nextPutAll: (self translateLengths: array2);
		nextPutAll: '		yourself'; newLine.
	aClass class compile: str contents! !

!CompileFields class methodsFor: 'compiling' stamp: 'dhn 8/10/2015 17:58'!
translateLengths: array2
	"Answer the field names, lengths,  justification, and padding translated into dictionary entries"
	"array2 is an array of arrays"
	| str pos |
	str _ String new writeStream.
	pos _ 1.
	array2 do: [:ea |
		str 
			nextPutAll: '		at: #';
			nextPutAll: ea first;
			nextPutAll: ' put: (Field '.
			
			ea size = 2
				ifTrue: [
					str nextPutAll: 'at: ';
					nextPutAll: pos asString.
					pos _ pos + ea second.
					ea second > 1
						ifTrue: [
							str 
								nextPut: $@;
								nextPutAll: (pos - 1) asString].
					str	nextPutAll: ');'; newLine].
				
			ea size = 3 
			ifTrue: [
				str nextPutAll: (self translateTriple: ea at: pos).
				pos _ pos + ea second].
			
			ea size = 4
				ifTrue: [
					str nextPutAll: 'at: ';
					nextPutAll: pos asString.
					pos _ pos + ea second.
					str 
						nextPut: $@;
						nextPutAll: (pos - 1) asString;
						nextPutAll: ' left: ';
						nextPutAll: ea third asString;
						nextPutAll: ' with: $';
						nextPutAll: ea fourth asString;
						nextPutAll: ');'; newLine].
		].
				
	^ str contents

"
Arrays in the array of arrays can be as follows:

(#name		size)	which produces:
	at: #name put: (Field at: aPoint);

(#name		size	pad)	pad is a character, which produces:
	at: #name put: (Field at: aPoint left: true with: pad);
	
(#name		1		pad)	which produces:
	at: #name put: (Field character: pad at: position);

(#name		size	justification)	justification is a boolean, which produces:
	at: #name put: (Field at: aPoint left: justification);

(#name		size	justification	pad)	which produces:
	at: #name put: (Field at: aPoint left: justification with: pad);

"! !

!CompileFields class methodsFor: 'compiling' stamp: 'dhn 8/10/2015 17:55'!
translateTriple: ea at: position
	"Answer the remainder of the dictionary entry for: 
		#(#name size pad),
		#(#name 1 pad), or
		#(#name size justification)"
	| str pos |
	pos _ position.
	str _ String new writeStream.
	ea second = 1
		ifTrue: [
			str
				nextPutAll: 'character: $';
				nextPutAll: ea third asString;
				nextPutAll: ' at: ';
				nextPutAll: pos asString;
				nextPutAll: ');'; newLine]
		ifFalse: [
			str
				nextPutAll: 'at: ';
				nextPutAll: pos asString.
				pos _ pos + ea second.
			str
				nextPut: $@;
				nextPutAll: (pos - 1) asString;
				nextPutAll: ' left: '.
			ea third class = Character
				ifTrue: [str nextPutAll: 'true with: $'].
			str 
				nextPutAll: ea third asString;
				nextPutAll: ');'; newLine].
	^ str contents
		! !

!ExampleGroup methodsFor: 'as yet unclassified' stamp: 'dhn 1/19/2015 17:27'!
initialize
	super initialize.
	ExampleLayout handler: self.
! !

!ExampleGroup methodsFor: 'as yet unclassified' stamp: 'dhn 1/19/2015 18:16'!
paidSub
	"Answer the value of paidSub"
	paidSub ifNil: [paidSub _ 0].
	^ paidSub! !

!ExampleGroup methodsFor: 'as yet unclassified' stamp: 'dhn 1/19/2015 18:16'!
paidSub: anObject
	"Set the value of paidSub"
	paidSub _ anObject! !

!ExampleGroup methodsFor: 'as yet unclassified' stamp: 'dhn 1/19/2015 18:16'!
paidTotal
	"Answer the value of paidTotal"
	paidTotal ifNil: [paidTotal _ 0].
	^ paidTotal! !

!ExampleGroup methodsFor: 'as yet unclassified' stamp: 'dhn 1/19/2015 18:15'!
paidTotal: anObject
	"Set the value of paidTotal"
	paidTotal _ anObject! !

!ExampleGroup methodsFor: 'as yet unclassified' stamp: 'dhn 1/19/2015 18:15'!
payeesSub
	"Answer the value of payeesSub"
	payeesSub ifNil: [payeesSub _ 0].
	^ payeesSub! !

!ExampleGroup methodsFor: 'as yet unclassified' stamp: 'dhn 1/19/2015 18:15'!
payeesSub: anObject
	"Set the value of payeesSub"
	payeesSub _ anObject! !

!ExampleGroup methodsFor: 'as yet unclassified' stamp: 'dhn 1/19/2015 18:15'!
payeesTotal
	"Answer the value of payeesTotal"
	payeesTotal ifNil: [payeesTotal _ 0].
	^ payeesTotal! !

!ExampleGroup methodsFor: 'as yet unclassified' stamp: 'dhn 1/19/2015 18:14'!
payeesTotal: anObject
	"Set the value of payeesTotal"
	payeesTotal _ anObject! !

!ExampleGroup methodsFor: 'as yet unclassified' stamp: 'dhn 1/19/2015 18:14'!
payerTotal
	"Answer the value of payerTotal"
	payerTotal ifNil: [payerTotal _ 0].
	^ payerTotal! !

!ExampleGroup methodsFor: 'as yet unclassified' stamp: 'dhn 1/19/2015 18:14'!
payerTotal: anObject
	"Set the value of payerTotal"
	payerTotal _ anObject! !

!ExampleGroup methodsFor: 'as yet unclassified' stamp: 'dhn 1/19/2015 18:25'!
realFile: aFilename
	"Produce the file for reporting 1099-MISC via FIRE, the IRS electronic reporting system"
	(StandardFileStream forceNewFileNamed: aFilename)
		nextPutAll: ExampleRecord1 new realA;
		nextPutAll: ExampleRecord2 new mnmB;
		nextPutAll: ExampleRecord2 new dhnB;
		nextPutAll: ExampleRecord3 new realC;
		close.
	Object inform: 'Example group of records written to: ', aFilename! !

!ExampleGroup methodsFor: 'as yet unclassified' stamp: 'dhn 1/19/2015 17:54'!
seq
	"Answer the value of seq"
	seq ifNil: [seq _ 0].
	^ seq! !

!ExampleGroup methodsFor: 'as yet unclassified' stamp: 'dhn 1/19/2015 17:54'!
seq: anObject
	"Set the value of seq"
	seq _ anObject! !

!ExampleGroup class methodsFor: 'as yet unclassified' stamp: 'dhn 6/8/2015 15:58'!
how
"
	ExampleGroup makeFile.
"
! !

!ExampleGroup class methodsFor: 'as yet unclassified' stamp: 'dhn 1/19/2015 17:23'!
makeFile
	| fileName |
	fileName := FillInTheBlankMorph 
		request: 'What should the output file be called?' 
		initialAnswer: 'c:\worx\myoutfile.txt'.
	self new realFile: fileName! !

!Field methodsFor: 'accessing' stamp: 'dhn 7/2/2015 11:54'!
at: anObject
	"Set the receiver to anObject"
	anObject class = Point
		ifFalse: [^ anObject asPoint].
	^ anObject! !

!Field methodsFor: 'accessing' stamp: 'dhn 1/17/2015 14:44'!
left
	"Answer the value of left"
	left ifNil: [left _ true].
	^ left! !

!Field methodsFor: 'accessing' stamp: 'dhn 1/17/2015 14:45'!
left: aBool
	"Set whether justification will be left (true) or right (false)"
	left _ aBool! !

!Field methodsFor: 'accessing' stamp: 'dhn 1/17/2015 15:04'!
length
	"Answer the length of the field"
	^ 1 + location y - location x! !

!Field methodsFor: 'accessing' stamp: 'dhn 1/17/2015 14:45'!
location
	"Answer the value of location"
	^ location! !

!Field methodsFor: 'accessing' stamp: 'dhn 8/7/2015 15:33'!
location: anObject
	"Set the value of location as from@to"
	location _ anObject asPoint! !

!Field methodsFor: 'accessing' stamp: 'dhn 1/17/2015 14:47'!
pad
	"Answer the value of pad. The default is a blank character"
	pad ifNil: [pad _ $ ].
	^ pad! !

!Field methodsFor: 'accessing' stamp: 'dhn 1/17/2015 14:46'!
pad: anObject
	"Set the value of pad"
	pad _ anObject! !

!Field class methodsFor: 'basic' stamp: 'dhn 1/17/2015 14:48'!
at: aPoint
	"Establish the receiver with no padding or justification. The first position of the receiver is aPoint x; the last is aPoint y"
	^ self new location: aPoint! !

!Field class methodsFor: 'basic' stamp: 'dhn 1/17/2015 14:48'!
at: aPoint left: aBool
	"Establish Character blank as the padding character for the receiver. Data in the receiver will be left-justified if aBool is true and right-justified otherwise. The first position of the receiver is aPoint x; the last is aPoint y"
	^ self new location: aPoint; left: aBool! !

!Field class methodsFor: 'basic' stamp: 'dhn 1/17/2015 14:49'!
at: aPoint left: aBool with: aCharacter
	"Establish aCharacter as the padding character for the receiver. Data in the receiver will be left-justified if aBool is true and right-justified otherwise. The first position of the receiver is aPoint x; the last is aPoint y"
	^ self new location: aPoint; left: aBool; pad: aCharacter! !

!Field class methodsFor: 'basic' stamp: 'dhn 8/10/2015 13:17'!
at: aLocation with: aCharacter
	"Establish a single character for the receiver (not for strings). The first position of the receiver is aPoint x; the last is aPoint y"
	^ self new location: aLocation; pad: aCharacter! !

!Field class methodsFor: 'coherent' stamp: 'dhn 8/10/2015 13:15'!
character: aCharacter at: aLocation
	"Specify a literal character of value aCharacter at aLocation"
	^ self at: aLocation with: aCharacter! !

!Field class methodsFor: 'coherent' stamp: 'dhn 1/17/2015 15:13'!
leftJustifyAt: aPoint
	^ self at: aPoint; left: true! !

!Field class methodsFor: 'coherent' stamp: 'dhn 1/17/2015 15:19'!
leftJustifyAt: aPoint with: aCharacter
	^ self at: aPoint left: true with: aCharacter! !

!Field class methodsFor: 'coherent' stamp: 'dhn 8/7/2015 14:59'!
rightJustifyAt: aPoint
	^ self at: aPoint left: false! !

!Field class methodsFor: 'coherent' stamp: 'dhn 1/17/2015 15:19'!
rightJustifyAt: aPoint with: aCharacter
	^ self at: aPoint left: false with: aCharacter! !

!RecordLayout methodsFor: 'accessing' stamp: 'dhn 1/19/2015 11:14'!
assemble: anObject 
	"Answer the record formed by populating the fields with data from
	anObject "
	^ self assemble: anObject endingWith: String crlfString
! !

!RecordLayout methodsFor: 'accessing' stamp: 'dhn 1/19/2015 11:09'!
assemble: anObject endingWith: aStringOrCharacter
	"Answer the record formed by populating the fields with data from
	anObject. The record is terminated with aStringOrCharacter "
	| str sort |
	str _ String new writeStream.
	sort _ OrderedCollection new.
	self class fields
		associationsDo: [:a | sort addFirst: a value location x -> a key].
	sort asSortedCollection
		do: [:s | str
				nextPutAll: (self for: s value put: (anObject at: s value))].
	str nextPutAll: aStringOrCharacter asString.
	^ str contents! !

!RecordLayout methodsFor: 'accessing' stamp: 'dhn 1/17/2015 18:11'!
data
	"Answer the value of data"
	^ data! !

!RecordLayout methodsFor: 'accessing' stamp: 'dhn 1/17/2015 18:24'!
data: anObject
	"Set the value of data"
	data _ anObject! !

!RecordLayout methodsFor: 'accessing' stamp: 'dhn 1/19/2015 11:26'!
fieldDefaults: aDictionary
	"Answer a dictionary of field names which are copied from aDictionary and associated with strings filled with the pad character of the field. The length of each string equals the length of its field"
	| dix |
	dix _ Dictionary new.
	aDictionary keysAndValuesDo: [:aKey :aValue | 
		dix at: aKey put: (self fillWith: aValue pad for: aValue length)].
	^ dix! !

!RecordLayout methodsFor: 'accessing' stamp: 'dhn 1/17/2015 18:12'!
fillWith: aCharacter for: aLength
	"Answer a string of length aLength, filled with aCharacter"
	| str |
	str _ String new: aLength.
	1 to: aLength do: [:n | str at: n put: aCharacter].
	^ str! !

!RecordLayout methodsFor: 'accessing' stamp: 'dhn 8/9/2015 12:58'!
for: aSymbol put: aString
	"Answer the contents of  of a field named  aSymbol, justifying it (#left or #right) and padding it with the pad	character, if required."
	| field padding rest source str padChar |
	
	field _ self class fields at: aSymbol.
	rest _ field length - aString size.
	padChar _ field pad.
	source _ aString.
	
	rest > 0 ifTrue: [
		padding _ String new: rest.
		1 to: rest do: [:n | padding at: n put: padChar]].
	
	rest = 0 ifTrue: [padding _ ''].
	
	rest < 0 ifTrue: [
				Transcript 
					nextPutAll: '''', aString, ''' for ', aSymbol, ' in ', self class asString, ' is too long.';
					newLine.
				padChar _ $!!.
				source _ ''.
				padding _ String new: field length.
				1 to: field length do: [:n | padding at: n put: padChar]].
			
	str _ String new writeStream.
	field left
		ifTrue: [str nextPutAll: source.
			str nextPutAll: padding]
		ifFalse: [str nextPutAll: padding.
			str nextPutAll: source].
	^ str contents! !

!RecordLayout methodsFor: 'initialize-release' stamp: 'dhn 1/17/2015 18:14'!
initialize
	super initialize.
	self data: (self fieldDefaults: self class fields).
! !

!RecordLayout class methodsFor: 'documentation' stamp: 'dhn 6/8/2015 15:38'!
explain
	^
	'Subclasses of RecordLayout should have a class method named #fields which defines the relationship among fields similar to the following example:
	
fields
	^ Dictionary new
		at: #Type put: (Field character: $F at: 1);
		at: #Acount put: (Field rightJustifyAt: 2@9 with: $0);
		at: #Zeros put: (Field rightJustifyAt: 10@30 with: $0);
		at: #Blank1 put: (Field at: 31@49);
		at: #Payees put: (Field rightJustifyAt: 50@57 with: $0);
		at: #Blank2 put: (Field at: 58@499);
		at: #Sequence put: (Field rightJustifyAt: 500@507 with: $0);
		at: #Blank3 put: (Field at: 508@748);
		yourself
'! !

!RecordLayout class methodsFor: 'documentation' stamp: 'dhn 1/19/2015 11:20'!
fields
	self error: '#fields should be implemented in subclasses of RecordLayout.'! !

!RecordLayout class methodsFor: 'accessing' stamp: 'dhn 1/17/2015 15:03'!
handler
	"Answer the value of Handler"
	^ Handler! !

!RecordLayout class methodsFor: 'accessing' stamp: 'dhn 1/19/2015 11:17'!
handler: anObject
	"Set the value of Handler to anObject which handles relations among records"
	Handler _ anObject! !

!RecordLayout class methodsFor: 'documentation' stamp: 'dhn 6/8/2015 15:47'!
how
	(TextModelMorph withText: self explain)
		morphExtent: 485@230;
		openInHand.! !

!RecordLayout class methodsFor: 'documentation' stamp: 'dhn 1/17/2015 15:04'!
recl
	"Answer the record length"
	self subclassResponsibility! !

!ExampleLayout methodsFor: 'as yet unclassified' stamp: 'dhn 1/19/2015 17:40'!
address: aString
	self data at: #Address put: aString! !

!ExampleLayout methodsFor: 'as yet unclassified' stamp: 'dhn 1/19/2015 17:40'!
city: aString
	self data at: #City put: aString! !

!ExampleLayout methodsFor: 'as yet unclassified' stamp: 'dhn 1/19/2015 17:49'!
dhnB
	| x |
	self year: self lastYear;
		name: 'HOPPER JOB JR';
		address: '1585 DEAD END DR';
		city: 'PEAWELL';
		state: 'NY';
		zip: '21075'.
	self data at: #TINtype put: '2'.
	self data at: #StateCode put: self stateCode.
	x _ FillInTheBlankMorph request: 'TIN for ', (self data at: #Name).
	self tin: x.
	x _ FillInTheBlankMorph request: 'Amount of payment 1 for ', (self data at: #Name).
	self data at: #Payment1 put: (self payment1: x asInteger).
	x _ FillInTheBlankMorph request: 'Amount of payment 2 for ', (self data at: #Name).
	self data at: #Payment2 put: (self payment1: x asInteger).
	self sequence.
	^ self assemble: self data! !

!ExampleLayout methodsFor: 'as yet unclassified' stamp: 'dhn 1/19/2015 17:40'!
initialize
	super initialize
! !

!ExampleLayout methodsFor: 'as yet unclassified' stamp: 'dhn 1/19/2015 17:39'!
lastYear
	^ (DateAndTime now yearNumber - 1) asString! !

!ExampleLayout methodsFor: 'as yet unclassified' stamp: 'dhn 1/19/2015 17:51'!
mnmB
	| x |
	self year: self lastYear;
		name: 'MOONEY MILTON';
		address: '923 FLOWER LN';
		city: 'ROME';
		state: 'NY';
		zip: '20861'.
	self data at: #TINtype put: '2'.
	self data at: #StateCode put: self stateCode.
	x := FillInTheBlankMorph request: 'TIN for ', (self data at: #Name).
	self tin: x.
	x := FillInTheBlankMorph request: 'Amount for ', (self data at: #Name).
	self data at: #Payment1 put: (self payment1: x asInteger).
	self sequence.
	^ self assemble: self data! !

!ExampleLayout methodsFor: 'as yet unclassified' stamp: 'dhn 1/19/2015 17:39'!
name: aString
	data at: #Name put: aString.
	data at: #Namectl put: (aString copyFrom: 1 to: 4).! !

!ExampleLayout methodsFor: 'as yet unclassified' stamp: 'dhn 1/19/2015 18:11'!
realA
	| obj |
	obj := self class handler.
	obj payeesTotal: obj payeesSub.
	obj payeesSub: 0.
	obj paidTotal: obj paidSub.
	obj paidSub: 0.
	obj payerTotal: obj payerTotal + 1.
	self year: self lastYear;
		tin: '582004343';
		name: 'BOGUS CATTLE LLC';
		address: '10110 DRY LAUREL DR';
		city: 'ROSWELL';
		state: 'NM';
		zip: '90075';
		telephone: '8000587552'.
	self data at: #Combined put: '0'.
	self data at: #TypeReturn put: 'A'.
	self data at: #AmountCodes put: '1'.
	self sequence.
	^ self assemble: self data! !

!ExampleLayout methodsFor: 'as yet unclassified' stamp: 'dhn 1/19/2015 18:31'!
realC
	self data at: #Payees put: self class handler payeesSub asString.
	self data at: #Control1 put: self class handler paidSub asString.
	self class handler payeesTotal: self class handler payeesTotal + self class handler payeesSub.
	self sequence.
	^ self assemble: self data! !

!ExampleLayout methodsFor: 'as yet unclassified' stamp: 'dhn 1/19/2015 17:39'!
sequence
	self class handler seq: 1 + self class handler seq.
	data at: #Sequence put: self class handler seq asString! !

!ExampleLayout methodsFor: 'as yet unclassified' stamp: 'dhn 1/19/2015 17:38'!
state: aString
	data at: #State put: aString! !

!ExampleLayout methodsFor: 'as yet unclassified' stamp: 'dhn 1/19/2015 17:38'!
stateCode
	^ '13' "Georgia"! !

!ExampleLayout methodsFor: 'as yet unclassified' stamp: 'dhn 1/19/2015 17:38'!
telephone: aString
	data at: #Telephone put: aString! !

!ExampleLayout methodsFor: 'as yet unclassified' stamp: 'dhn 1/19/2015 20:20'!
testB01
	self year: self lastYear;
		tin: '123374343';
		name: 'MAGOO MALCOLM';
		address: '4310B JAMES CIRCLE';
		city: 'RENATE';
		state: 'NC';
		zip: '23988'.
	self data at: #Payment1 put: (self payment1: 87143).
	self data at: #TINtype put: '2'.
	self data at: #StateCode put: self stateCode.
	self sequence.
	^ self assemble: self data! !

!ExampleLayout methodsFor: 'as yet unclassified' stamp: 'dhn 1/19/2015 17:37'!
tin: aString
	data at: #TIN put: aString! !

!ExampleLayout methodsFor: 'as yet unclassified' stamp: 'dhn 1/19/2015 17:37'!
year: aString
	data at: #Year put: aString! !

!ExampleLayout methodsFor: 'as yet unclassified' stamp: 'dhn 1/19/2015 17:36'!
zip: aString
	data at: #Zip put: aString! !

!ExampleLayout class methodsFor: 'as yet unclassified' stamp: 'dhn 1/19/2015 20:49'!
recl
	"Answer the length of records"
	^ 750 - String crlfString size! !

!ExampleRecord1 methodsFor: 'as yet unclassified' stamp: 'dhn 1/19/2015 17:16'!
initialize
	super initialize.
! !

!ExampleRecord1 class methodsFor: 'as yet unclassified' stamp: 'dhn 1/19/2015 17:20'!
fields
	"Answer the A Record definition consisting of field names, positions, justification, and padding"
	^ Dictionary new
		at: #Type put: (Field character: $A at: 1);
		at: #Year put: (Field at: 2@5);
		at: #Combined put: (Field at: 6@6);
		at: #Blank1 put: (Field at: 7@11);
		at: #TIN put: (Field at: 12@20);
		at: #Namectl put: (Field at: 21@24);
		at: #LastFiling put: (Field at: 25@25);
		at: #TypeReturn put: (Field at: 26@27);
		at: #AmountCodes put: (Field at: 28@43);
		at: #Blank2 put: (Field at: 44@51);
		at: #Foreign put: (Field at: 52@52);
		at: #Name put: (Field at: 53@92);
		at: #Namex put: (Field at: 93@132);
		at: #TransferAgent put: (Field at: 133@133);
		at: #Address put: (Field at: 134@173);
		at: #City put: (Field at: 174@213);
		at: #State put: (Field at: 214@215);
		at: #Zip put: (Field at: 216@224);
		at: #Telephone put: (Field at: 225@239);
		at: #Blank3 put: (Field at: 240@499);
		at: #Sequence put: (Field rightJustifyAt: 500@507 with: $0);
		at: #Blank4 put: (Field at: 508@748);
		yourself! !

!ExampleRecord2 methodsFor: 'as yet unclassified' stamp: 'dhn 1/19/2015 17:15'!
initialize
	super initialize.
! !

!ExampleRecord2 methodsFor: 'as yet unclassified' stamp: 'dhn 1/19/2015 17:17'!
payment1: anAmount
	self class handler paidSub: self class handler paidSub + anAmount.
	self class handler payeesSub: self class handler payeesSub + 1.
	^ anAmount asString! !

!ExampleRecord2 class methodsFor: 'as yet unclassified' stamp: 'dhn 1/19/2015 17:19'!
fields
	"Answer the B Record definition consisting of field names, positions, justification, and padding"
	^ Dictionary new
		at: #Type put: (Field character: $B at: 1);
		at: #Year put: (Field at: 2@5);
		at: #Corrected put: (Field at: 6@6);
		at: #Namectl put: (Field at: 7@10);
		at: #TINtype put: (Field at: 11@11);
		at: #TIN put: (Field at: 12@20);
		at: #Account put: (Field at: 21@40);
		at: #OfficeCode put: (Field at: 41@44);
		at: #Blank1 put: (Field at: 45@54);
		at: #Payment1 put: (Field rightJustifyAt: 55@66 with: $0);
		at: #Payment2 put: (Field rightJustifyAt: 67@78 with: $0);
		at: #Payment3 put: (Field rightJustifyAt: 79@90 with: $0);
		at: #Payment4 put: (Field rightJustifyAt: 91@102 with: $0);
		at: #Payment5 put: (Field rightJustifyAt: 103@114 with: $0);
		at: #Payment6 put: (Field rightJustifyAt: 115@126 with: $0);
		at: #Payment7 put: (Field rightJustifyAt: 127@138 with: $0);
		at: #Payment8 put: (Field rightJustifyAt: 139@150 with: $0);
		at: #Payment9 put: (Field rightJustifyAt: 151@162 with: $0);
		at: #PaymentA put: (Field rightJustifyAt: 163@174 with: $0);
		at: #PaymentB put: (Field rightJustifyAt: 175@186 with: $0);
		at: #PaymentC put: (Field rightJustifyAt: 187@198 with: $0);
		at: #PaymentD put: (Field rightJustifyAt: 199@210 with: $0);
		at: #PaymentE put: (Field rightJustifyAt: 211@222 with: $0);
		at: #PaymentF put: (Field rightJustifyAt: 223@234 with: $0);
		at: #PaymentG put: (Field rightJustifyAt: 235@246 with: $0);
		at: #Foreign put: (Field at: 247@247);
		at: #Name put: (Field at: 248@287);
		at: #Namex put: (Field at: 288@327);
		at: #Blank2 put: (Field at: 328@367);
		at: #Address put: (Field at: 368@407);
		at: #Blank3 put: (Field at: 408@447);
		at: #City put: (Field at: 448@487);
		at: #State put: (Field at: 488@489);
		at: #Zip put: (Field at: 490@498);
		at: #Blank4 put: (Field at: 499@499);
		at: #Sequence put: (Field rightJustifyAt: 500@507 with: $0);
		at: #Blank5 put: (Field at: 508@543);
		at: #TINnotice put: (Field at: 544@544);
		at: #Blank6 put: (Field at: 545@546);
		at: #DirectSales put: (Field at: 547@547);
		at: #Blank7 put: (Field at: 548@662);
		at: #SpecialData put: (Field at: 663@722);
		at: #StateWitheld put: (Field at: 723@734);
		at: #LocalWitheld put: (Field at: 735@746);
		at: #StateCode put: (Field at: 747@748);
		yourself! !

!ExampleRecord3 methodsFor: 'as yet unclassified' stamp: 'dhn 1/19/2015 17:15'!
initialize
	super initialize.

! !

!ExampleRecord3 class methodsFor: 'as yet unclassified' stamp: 'dhn 1/19/2015 17:19'!
fields
	"Answer the C Record definition consisting of field names, positions, justification, and padding"
	^ Dictionary new
		at: #Type put: (Field character: $C at: 1);
		at: #Payees put: (Field rightJustifyAt: 2@9 with: $0);
		at: #Blank1 put: (Field at: 10@15);
		at: #Control1 put: (Field rightJustifyAt: 16@33 with: $0);
		at: #Control2 put: (Field rightJustifyAt: 34@51 with: $0);
		at: #Control3 put: (Field rightJustifyAt: 52@69 with: $0);
		at: #Control4 put: (Field rightJustifyAt: 70@87 with: $0);
		at: #Control5 put: (Field rightJustifyAt: 88@105 with: $0);
		at: #Control6 put: (Field rightJustifyAt: 106@123 with: $0);
		at: #Control7 put: (Field rightJustifyAt: 124@141 with: $0);
		at: #Control8 put: (Field rightJustifyAt: 142@159 with: $0);
		at: #Control9 put: (Field rightJustifyAt: 160@177 with: $0);
		at: #ControlA put: (Field rightJustifyAt: 178@195 with: $0);
		at: #ControlB put: (Field rightJustifyAt: 196@213 with: $0);
		at: #ControlC put: (Field rightJustifyAt: 214@231 with: $0);
		at: #ControlD put: (Field rightJustifyAt: 232@249 with: $0);
		at: #ControlE put: (Field rightJustifyAt: 250@267 with: $0);
		at: #ControlF put: (Field rightJustifyAt: 268@285 with: $0);
		at: #ControlG put: (Field rightJustifyAt: 286@303 with: $0);
		at: #Blank2 put: (Field at: 304@499);
		at: #Sequence put: (Field rightJustifyAt: 500@507 with: $0);
		at: #Blank3 put: (Field at: 508@748);
		yourself! !

!AbutmentTests methodsFor: 'as yet unclassified' stamp: 'dhn 1/19/2015 21:22'!
checkConsistency: aClass 
	"Verify that Fields of aClass abut with no gaps or overlap"
	| dix prev uns |
	dix _ aClass fields.
	uns _ OrderedCollection new.
	dix
		associationsDo: [:a | uns addFirst: a value location x -> a key].
	prev _ 0.
	uns asSortedCollection
		do: [:a | 
			self
				should: [((dix at: a value) location x)
						= (prev + 1)].
			prev := (dix at: a value) location y]! !

!AbutmentTests methodsFor: 'as yet unclassified' stamp: 'dhn 1/19/2015 21:21'!
testRecords
	self checkConsistency: ExampleRecord1.
	self checkConsistency: ExampleRecord2.
	self checkConsistency: ExampleRecord3.
! !

!SizeTests methodsFor: 'as yet unclassified' stamp: 'dhn 1/19/2015 19:39'!
data: length with: string
	| str |
	str _ (String new: length - 1) writeStream.
	length - 1 timesRepeat: [str nextPut: string].
	^ str contents! !

!SizeTests methodsFor: 'as yet unclassified' stamp: 'dhn 1/19/2015 19:44'!
fillData: aClass 
	"Put visible characters in every field longer than 1, leaving room for one pad character."
	| dat record str fields sort i fld |
	dat _ 'abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz'.
	str _ String new writeStream.
	record _ aClass new.
	fields _ aClass fields.
	sort _ OrderedCollection new.
	fields
		associationsDo: [:a | sort addFirst: a value location x -> a key].
	i _ 0.
	sort asSortedCollection
		do: [:s | 
			fld _ fields at: s value.
			i _ i + 1.
			str
				nextPutAll: (record for: s value put: (self data: fld length with: (dat at: i)))].
	self
		should: [str size = ExampleLayout recl].
	^ str contents! !

!SizeTests methodsFor: 'as yet unclassified' stamp: 'dhn 1/19/2015 20:33'!
padOnly: aClass 
	| record str fields sort |
	str _ String new writeStream.
	record _ aClass new.
	fields _ aClass fields.
	sort _ OrderedCollection new.
	fields
		associationsDo: [:a | sort addFirst: a value location x -> a key].
	sort asSortedCollection
		do: [:s | 
			str
				nextPutAll: (record for: s value put: '')].
	self
		should: [str size = ExampleLayout recl].
	^ str contents! !

!SizeTests methodsFor: 'as yet unclassified' stamp: 'dhn 1/19/2015 19:51'!
recLength: aClass 
	| fields ttl |
	fields _ aClass fields.
	ttl _ 0.
	fields
		do: [:f | ttl _ ttl + f length].
	self
		should: [ttl = ExampleLayout recl]! !

!SizeTests methodsFor: 'as yet unclassified' stamp: 'dhn 2/9/2015 11:01'!
setUp
	"Establish class variable #Handler in Record class"
	^ ExampleGroup new! !

!SizeTests methodsFor: 'as yet unclassified' stamp: 'dhn 1/19/2015 19:53'!
testDataA
	^ self fillData: ExampleRecord1! !

!SizeTests methodsFor: 'as yet unclassified' stamp: 'dhn 1/19/2015 19:53'!
testDataB
	^ self fillData: ExampleRecord2! !

!SizeTests methodsFor: 'as yet unclassified' stamp: 'dhn 1/19/2015 19:53'!
testDataC
	^ self fillData: ExampleRecord3
	! !

!SizeTests methodsFor: 'as yet unclassified' stamp: 'dhn 1/19/2015 19:56'!
testEmpty
	| ttl |
	ttl _ ExampleRecord1 new realA size.
	self
		should: [ttl = (ExampleLayout recl +2)].
	ttl _ ExampleRecord2 new testB01 size.
	self
		should: [ttl = (ExampleLayout recl +2)].
	ttl _ ExampleRecord3 new realC size.
	self
		should: [ttl = (ExampleLayout recl +2)].
! !

!SizeTests methodsFor: 'as yet unclassified' stamp: 'dhn 1/19/2015 20:32'!
testPadA
	^ self padOnly: ExampleRecord1! !

!SizeTests methodsFor: 'as yet unclassified' stamp: 'dhn 1/19/2015 19:58'!
testPadB
	^ self padOnly: ExampleRecord2! !

!SizeTests methodsFor: 'as yet unclassified' stamp: 'dhn 1/19/2015 21:10'!
testPadC
	^ self padOnly: ExampleRecord3! !

!SizeTests methodsFor: 'as yet unclassified' stamp: 'dhn 1/19/2015 20:38'!
testSizeA
	self recLength: ExampleRecord1! !

!SizeTests methodsFor: 'as yet unclassified' stamp: 'dhn 1/19/2015 20:39'!
testSizeB
	self recLength: ExampleRecord2! !

!SizeTests methodsFor: 'as yet unclassified' stamp: 'dhn 1/19/2015 20:39'!
testSizeC
	self recLength: ExampleRecord3! !
