/*
*  Copyright (C) 2010  INdT - Instituto Nokia de Tecnologia
*
*  NDG is free software; you can redistribute it and/or
*  modify it under the terms of the GNU Lesser General Public
*  License as published by the Free Software Foundation; either 
*  version 2.1 of the License, or (at your option) any later version.
*
*  NDG is distributed in the hope that it will be useful,
*  but WITHOUT ANY WARRANTY; without even the implied warranty of
*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
*  Lesser General Public License for more details.
*
*  You should have received a copy of the GNU Lesser General Public 
*  License along with NDG.  If not, see <http://www.gnu.org/licenses/ 
*/

package main.br.org.indt.ndg.controller.editor {
	
	
	import flash.utils.ByteArray;
	
	import mx.collections.XMLListCollection;
	
	
	//singleton
	public class Survey{
		
		private static var instance:Survey;
		private var questionaryList:XMLListCollection;
		private var questionary:XML;

		public static function getInstance(): Survey {
			if (instance == null) {
				instance = new Survey(new PrivateClass());
			}
			return instance;
		}
		
		//TODO: MUST me private for Singleton to work
		public function Survey(pvt: PrivateClass) {
			var surveyID:Number = getNewSurveyID();
			questionary = <survey display="1-1" id={surveyID} title="" deployed="false"></survey>;
			questionaryList = new XMLListCollection(questionary.category);	
		}
		
		public function appendCategory(category:Category):void{
			questionaryList.addItem(category.getContent());
		}
		public function removeCategory(iPos:int):void{
			questionaryList.removeItemAt(iPos);
		}
		
		public function getContent():XML{
			return questionary;
		}
		public function setContent(xml:XML):void{
			questionary = xml;
			questionaryList = new XMLListCollection(questionary.category);
		}
		public function getContentList():XMLListCollection{
			return questionaryList;
		}
		
		public function getCategoryCount():int{
			var categoryList:XMLList = questionary.category;
			return categoryList.length();
		}
		public function updateCategory(category:XML, updatedText:String):void{
			category.@name = updatedText;
		}	
		
		public function setSurveyName(strName:String):void{
			questionary.@title = strName;
		}
		public function getSurveyName():String {
			return questionary.@title;
		}
		
		public function setSurveyId(strId:String):void{
			questionary.@id = strId;
		}
		public function getSurveyId():String {
			return questionary.@id;
		}
		
		public function reset():void {
			var surveyID:int = getNewSurveyID();
			questionary = <survey display="1-1" id={surveyID} title="" deployed="false"></survey>;
			questionaryList = new XMLListCollection(questionary.category);		
		}

		public function setSurveyDeployed(bval: Boolean):void {
			questionary.@deployed = bval;
		}
		public function getSurveyDeployed(): Boolean {
			return questionary.@deployed == "true" ? true : false;
		}
		
		public function prepareSave():void {
			questionary.@checksum = "";
				
			var byteArr:ByteArray = new ByteArray();
			byteArr.writeUTFBytes(questionary.toXMLString());
			var strBuf: String = "";
			for (var i: int = 0; i < byteArr.length; i++){
				strBuf += String.fromCharCode(byteArr[i]);
			}
				
			var objMD5:ChecksumMD5 = new ChecksumMD5();
			var strMD5:String = objMD5.calcMD5(strBuf);
				
			questionary.@checksum = strMD5;
			// var strMD5:String = objMD5.calcMD5("The quick brown fox jumps over the lazy dog");
			// MD5("The quick brown fox jumps over the lazy dog") 
			// 9e107d9d372bb6826bd81d3542a419d6
		}
		
		// the range of values represented by the uint class is 0 to 4,294,967,295 (2^32-1)
		public function getNewSurveyID():uint {
			var now:Date = new Date();
			return now.getTime() / 1000;
		}
		
		public function isEmpty():Boolean {
			return !(questionaryList.length > 0);
		}
		
		
	}
	
}


class PrivateClass {
	public function PrivateClass(){};
}


