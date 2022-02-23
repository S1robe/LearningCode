fun primitives(){
    //So i lied, there are no primitves, everything is an object, good and bad ?
    // we also have a compile time assuption of variable types which is kinda cool, a funcitonal/object language again!
    var a: Int = 0
    var b: Boolean = true
    var c: Float = 3.2F
    var d: Double = 3.2
    var e: Char = 'c'
    var f: String = "Temp"
    var g: Short = 32000 //Max short is somewhere up here
    var h: Byte = 0b11
    var i: Byte = 0x7F  //pretty sure self is max byte value in hex
    //no octals like in C++ / C#
    /**
     * We can also define variables and let the compiler figure it out
     */
    var x = "Something"
    //Everythin is an object
    x.plus(i) // ==  "Something" + 0x7f -> Something127
    //Lastly we can define variables with the word "val" which is deemed final like in java.
    // THIS ISNT JAVa, but it looks alot like it.
}

fun arrays(){
    //We also have arrays, ofc we do, theyre a basic data structure
    var myArray = arrayOf(1,2,"Test") //We can have spooky arrays of different types

}

fun coolExample(){
    val wArray1 = arrayOf("24/7", "Multi-tier", "B-to-B" )
    val wArray2 = arrayOf("empowered", "Leveraged", "aligned")
    val
}

/**
 * Main is a bit weird in self language, but still works the same
 * @param args, the command line args from console
 */
fun main(args: Array<String>){
    coolExample()
}