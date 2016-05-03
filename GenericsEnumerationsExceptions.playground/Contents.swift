/*:
# Enumerations, Generics, Error Types and Exception Handling
 
## Understanding optionals as enumerations + generics

What's actually going on when you type

    let x: Int? = 25

As noted last time, classes, structures and enumerations all support generics.
 
To understand this, we need to understand how generics and enumerations work together.

### Review of Generics and Dictionaries
*/
let historicYears: Dictionary<String, Int> = ["Electron Discovered": 1897, "Transistor Created": 1947]
/*:
It is so common to want to supply the generic type for dictionaries that the language provides a shorthand:
*/
let moreHistoricYears: [String: Int] = ["iPhone Released": 2007, "Swift Released": 2014]
/*:
However, last time we didn't discuss how enumerations use generics.

Enumerations are usually used in very specific situations to list some specific possibilities, e.g.,
*/
enum CampusBuilding {
    case Garaventa
    case Galileo
    case Dante
}

let aBuilding: CampusBuilding = CampusBuilding.Garaventa
/*:
### Supplying Values for Cases

Sometimes you don't know all the cases in advance, in which case you can supply a way to make more cases:
*/
import CoreLocation

/* The following example is contrived. */

enum IconicBuilding<VagueAsYetUnspecified> {
    case EiffelTower
    case EmpireStateBuilding
    case Other(VagueAsYetUnspecified)
}

typealias IconicBuildingDefinedByString = IconicBuilding<String>

let eiffelTower = IconicBuildingDefinedByString.EiffelTower
let empireStateBuilding = IconicBuildingDefinedByString.EmpireStateBuilding
let transamericaPyramid = IconicBuildingDefinedByString.Other("TransamericaPyramid")

print("\(eiffelTower)")
print("\(empireStateBuilding)")
print("\(transamericaPyramid)")

typealias IconicBuildingDefinedByLocation = IconicBuilding<CLLocation>

let empLocation = CLLocation(latitude:47.6215, longitude: 122.3486)
let empMuseum = IconicBuildingDefinedByLocation.Other(empLocation)

print("\(empMuseum)")
/*:
### Putting it Together

Now we have enough examples that it is possible to show how enumerations and generics work together.

The idea is that you might like to have an enum that is re-usable in very different circumstances.

The only realistic example I know for this is optionals.

So let's make our own optional:
*/
enum OurOptional<WrappedType> {
    case Absent
    case Present(WrappedType)
}

enum AnotherEnum {
    case Present
    case Absent
}

let x: OurOptional<Int> = .Absent

print("x: OurOptional<Int> = .Absent ==> \(x)")

let y: OurOptional<Int> = .Present(3)

print("y: OurOptional<Int> = .Present(3) ==> \(y)")

let a: Optional<Int> = nil

print("a: Optional<Int> = nil gives \(a)")

let b: Optional<Int> = Optional<Int>(4)

print("b: Optional<Int> = Optional<Int>(4) ==> \(b)")

let c: Optional<Int> = 5

print("c: Optional<Int> = 5 ==> \(c)")

let d: Int? = nil

print("d: Int? = nil ==> \(d)")
/*:
## Error Types and Exceptions
 
In Swift you can modify a function's declaration to say that it can throw exceptions.

In most languages, an exception means that the function does not complete. The jargon in most languages is that throwing an exception "unwinds the call stack" to the point that the exception is caught.  You can think of it as a wild goto instruction.
 
In most languages, getting to the goto is said to be performance expensive, and exceptions should not be used frequently.

Here's how a function that throws is declared in Swift:
 
*/
func getTitleFromPlist(plistName: String) throws -> String {
    return "A title"
}

func functionThatCallsGetTitleFromPlist() -> String? {
    let plistName = "my_plist.plist"
    let result = try? getTitleFromPlist(plistName)
    return result
}

functionThatCallsGetTitleFromPlist()
/*:
Next we'll make the example more realistic.
 
### Type Example
*/
import Foundation

enum TitledPlistReaderError: ErrorType {
    case FileDoesNotExist
    case NotAPlist
    case UntitledPlist
}

func getTitleFromPlist2(plistName: String) throws -> String {
    if !plistName.hasSuffix(".plist") {
        throw TitledPlistReaderError.NotAPlist
    }
    
    guard let plistPath = NSBundle.mainBundle().pathForResource("my_plist", ofType: "plist") else {
        throw TitledPlistReaderError.FileDoesNotExist
    }
    
    let plist = NSDictionary(contentsOfFile: plistPath) as! [String: String]
    
    let title = plist["title"]
    
    if title == nil {
        throw TitledPlistReaderError.UntitledPlist
    }
    
    return title!
}

func functionThatCallsGetTitleFromPlist2() -> String? {
    let plistName = "my_plist.plist"
    do {
        return try getTitleFromPlist2(plistName)
    } catch TitledPlistReaderError.FileDoesNotExist {
        print("Plist file does not exist.")
        return nil
    } catch TitledPlistReaderError.NotAPlist {
        print("Not a plist.")
        return nil
    } catch TitledPlistReaderError.UntitledPlist {
        print("No title in the plist.")
        return nil
    } catch {
        print("Utterly unexpected error.")
        return nil
    }

}

functionThatCallsGetTitleFromPlist2()




