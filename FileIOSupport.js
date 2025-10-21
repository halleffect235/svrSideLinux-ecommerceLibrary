//
//
//
// 

//
// splitFile
//  receive the gross contents of a file, and split it into records for further processing
//
//    January 10, 2019, - jpl
//
//

     function splitFile(fC) {

          var retSplit = fC.split('\n');

          return retSplit;

     }

//
// getField
//  receive a files split into record content, and a string matching a field name
//  return the contents of a specific field found in the file's records
//
//     January 10, 2019 - jpl
//     January 11, 2019 - jpl changed to be valid only at beginning of record position "0"

    function getField(fileC, fieldName) {

        var i = 0;
        tmp = '';

        //alert(fileC.length + ' ' + fieldName);

        for(i = 0; i < fileC.length; i++) {
            if(fileC[i].indexOf(fieldName) == 0) {
                tmp = fileC[i];
                tmp = tmp.replace(/^.*?\"/, '');
                tmp = tmp.replace(/\".*$/, '');
                return tmp;
            }
        }

        return "-1";
    }

//
// updateField
//  input a record split file's contents, field name and replacement string of the field
//  return the file's contents with replaced field contents
//
//  this program assumes there is only one referrence to the field in the file contents, no duplicates
//

     function updateField(infileC, fieldName, fieldContent) {

         var i = 0;
         tmp = '';
         var fileC = [];
         fileC = infileC;

         fieldContent = fieldContent.replace(/\"/g, '_');
         //fieldContent = fieldContent.replace(/\s/g, '');
         for(i = 0; i < fileC.length; i++) {

             if(fileC[i].indexOf(fieldName) != -1) { 

                 fileC[i] = fileC[i].replace(/\".*\"/, '"' + fieldContent + '"');
                 return fileC;
             }
         }

         fileC.push(fieldName + '"' + fieldContent + '"');

         return fileC;

     }

     function removeDuplicateRecords(array) {

          var newArray  = [];
          var i         = 0;
          var tmp       = '';
          
          array = array.sort();
          tmp = array[0];

          for(i = 1; i < array.length; i++) {
               if(tmp != array[i]) {newArray.push(tmp);tmp = array[i];}               
          }
          newArray.push(tmp);
          return newArray;
     }


