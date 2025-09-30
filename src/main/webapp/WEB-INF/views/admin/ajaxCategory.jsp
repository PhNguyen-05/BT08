<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Category CRUD</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.1/css/all.min.css"/>
    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
    <script>var contextPath = "${pageContext.request.contextPath}"</script>
</head>
<body class="container mt-5">

<h2 class="mb-4">Category CRUD (Ajax)</h2>
<p><button class="btn btn-success" onclick="showCreateModal()"><i class="fa fa-plus"></i> Add Category</button></p>

<table class="table table-bordered table-striped">
    <thead><tr><th>ID</th><th>Name</th><th>Image</th><th>Actions</th></tr></thead>
    <tbody id="tableBody"></tbody>
</table>

<!-- Modal -->
<div class="modal fade" id="formModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form id="formData" enctype="multipart/form-data">
                <div class="modal-header">
                    <h5 class="modal-title">Category</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="categoryId" id="id"/>
                    <div class="mb-3"><label>Name</label><input type="text" name="categoryName" id="name" class="form-control"/></div>
                    <div class="mb-3"><label>Image</label><input type="file" name="icon" id="icon" class="form-control"/></div>
                </div>
                <div class="modal-footer"><button type="submit" class="btn btn-primary">Save</button></div>
            </form>
        </div>
    </div>
</div>

<script>
function loadData(){
    $.getJSON(contextPath+"/api/category", function(data){
        let rows="";
        data.forEach(c=>{
            rows+=`<tr>
                <td>${c.categoryId}</td>
                <td>${c.categoryName}</td>
                <td>${c.icon ? '<img src="'+contextPath+'/uploads/'+c.icon+'" width="50"/>' : ''}</td>
                <td>
                    <button class="btn btn-warning btn-sm" onclick='edit(${JSON.stringify(c)})'><i class="fa fa-edit"></i></button>
                    <button class="btn btn-danger btn-sm" onclick="remove(${c.categoryId})"><i class="fa fa-trash"></i></button>
                </td>
            </tr>`;
        });
        $("#tableBody").html(rows);
    });
}
function showCreateModal(){ $("#id").val(""); $("#name").val(""); $("#formModal").modal("show"); }
function edit(c){ $("#id").val(c.categoryId); $("#name").val(c.categoryName); $("#formModal").modal("show"); }
$("#formData").submit(function(e){
    e.preventDefault();
    let formData = new FormData(this);
    let url = $("#id").val()?"/api/category/updateCategory":"/api/category/addCategory";
    let method = $("#id").val()?"PUT":"POST";
    $.ajax({url:contextPath+url,type:method,data:formData,processData:false,contentType:false,success:function(){ $("#formModal").modal("hide"); loadData(); }});
});
function remove(id){ if(confirm("Delete?")) $.ajax({url:contextPath+"/api/category/deleteCategory?categoryId="+id,type:"DELETE",success:loadData}); }
$(document).ready(loadData);
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>