    var $j = jQuery.noConflict();
    var missionRecs = {};
    
    $j.ajaxSetup({
  		timeout: '120000'
		});

    /*
    function showLoadingModal() {
        $j.mobile.loadingMessageTextVisible = true;
        $j.mobile.showPageLoadingMsg("a", "Loading....", false);
    }
    */
    
    $j(window).ready(function() {
    
    	//$j.mobile.hidePageLoadingMsg();

    	/*    
        if (!navigator.onLine) {
             $j.mobile.changePage('#offline', {changeHash: true});
             return;
        }        
    
        $j(window).bind('offline',function(e){
            $j.mobile.changePage('#offline', {changeHash: true});
        })  
    	*/
    	
    });
    
    $j(window).resize(function() { 
        $j(".ui-header").width($j(window).width());
        $j(".ui-footer").width($j(window).width());
    });
    
    $j(document).trigger('salesforceSessionRefresh');
    $j(document).bind('salesforceSessionRefresh',function(e){
        //alert('session refreshed');
        //location.reload();
    });
            
    function completeMission(){
    	//Invoke the appropriate function based on the Mission Type
        var missionType = '{!Mission__c.Mission_Type__c}';
        if ( missionType == 'Camera'){
            cameraMissionAction();
        } else if (missionType == 'Scanner'){
            scannerMissionAction();
        } else if (missionType == 'Check-in'){
            checkInMissionAction();
        } else if (missionType == 'Signature'){
            signatureMissionAction();
        } else {
    		genericMissionAction();
        }
    }

    function showPopupMessage(msg, url){
        $j('#msg').html(msg);
        if(url){
            $j('#msgUrl').attr("href",url);
        }
        $j.mobile.changePage('#infoMsg', 'pop', true, true);  
    }

    function clearSignature(){
        $j('#signature').jSignature('clear');
        $j('#signature').css('display','none');
    }      

    function showNoList() {
      $j('#content').empty();
      var newContent = $j('<div></div>');
      newContent.attr('data-theme', 'c');
      newContent.append($j('<h2>The game is over. Thanks for playing!</h2>'));
      newContent.appendTo('#content');
    }
    
    function showMissionList(records, callback) {			
      $j('#missionList').empty();
      var x = 0;
      $j.each( records,
        function() {
            var newLi = $j('<li></li>');
            var mType = this.mission.Mission_Type__c;
            
            if(this.completed) {
	            newLi.attr('data-theme', 'a');
	            newLi.append(getMissionIcon(mType));
	            newLi.append($j('<h2>'+this.mission.Name+'</h2>').attr('style','text-decoration: line-through;'));
	            newLi.append($j('<h5 style="color: #4b7eb0">'+Math.round(this.pointsAwarded)+' points won</h5>'));
            } else {
	            newLi.attr('data-theme', 'c');
	            var child = $j('<a id="' +this.mission.Id+ '" href="{!URLFOR($Page.Mission)}?id=' + this.mission.Id + '&P={!$CurrentPage.parameters.P}&G={!$CurrentPage.parameters.G}" rel="external"></a>');
	            child.append(getMissionIcon(mType));
	            child.append($j('<h2>'+this.mission.Name+'</h2>'));
	            child.append($j('<h5 style="color: #4b7eb0">'+
	            Math.round(this.mission.Current_Point_Value__c)+' points available</h5>'));
	            newLi.append(child);
            }
            
            newLi.appendTo('#missionList');
            x++;
        }
     	);
      
      $j('#missionList').listview('refresh');
      $j.mobile.hidePageLoadingMsg();

			if(callback != null) { 
				callback(); 
			}
    }   
    