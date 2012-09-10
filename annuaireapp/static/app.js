var t;
var initialized = false;

$(document).ready(function() {
	$('#personForm').dialog({
		autoOpen:false, 
		modal:true, 
		title:"Edit Person", 
		buttons:{
			Save:function(){
				/*var f = $('#form')[0];
				f.action = '/persons/' + $("#id")[0].value;
				f.submit();*/
				$.ajax({
					url:'/persons/' + $("#id")[0].value,
					type:'PUT',
					data:{firstName:$("#prenom")[0].value, lastName:$("#nom")[0].value}
				}).done(function(res){
					$("#personForm" ).dialog("close");
				});
			},
			Cancel:function(){
				$(this).dialog("close");
			}
		}
	});

  t = $('#persons').dataTable( {
    "bProcessing": true,
    "sAjaxSource": "persons",
    "sAjaxDataProp": "persons",
    "aoColumns": [
        /*{ "mData": "engine" },
        { "mData": "browser" },
        { "mData": "id" },*/
        { "mData": "firstname" },
        { "mData": "lastname" }
    ],
		"fnInitComplete":function(oSettings, json){
			$( t.fnGetNodes() ).click( function (e) {
				$.ajax({
					url:'/persons/' + this.id,
					dataType:'json'
				}).done(function(res){
					$("#id")[0].value = res.id;
					$("#nom")[0].value = res.lastname;
					$("#prenom")[0].value = res.firstname;
				});
				$("#personId").html(this.id);
				$("#personForm" ).dialog("open");
			});
		},
		"fnRowCallback": function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {
      nRow.id = aData.id;
    }
  } );
} );
