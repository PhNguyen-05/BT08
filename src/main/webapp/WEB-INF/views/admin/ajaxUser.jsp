<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>User CRUD</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.1/css/all.min.css"/>
    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
    <script>var contextPath = "${pageContext.request.contextPath}"</script>
</head>
<body class="container mt-5">

<h2 class="mb-4">User CRUD (Ajax)</h2>
<p><button class="btn btn-success" onclick="showCreateModal()"><i class="fa fa-plus"></i> Add User</button></p>

<table class="table table-bordered table-striped">
    <thead><tr><th>ID</th><th>Fullname</th><th>Email</th><th>Phone</th><th>Actions</th></tr></thead>
    <tbody id="tableBody"></tbody>
</table>

<div class="modal fade" id="formModal" tabindex="-1">
    <div class="modal-dialog"><div class="modal-content">
        <form id="formData">
            <div class="modal-header"><h5 class="modal-title">User</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
            <div class="modal-body">
                <input type="hidden" name="id" id="id"/>
                <div class="mb-3"><label>Fullname</label><input type="text" name="fullname" id="fullname" class="form-control"/></div>
                <div class="mb-3"><label>Email</label><input type="email" name="email" id="email" class="form-control"/></div>
                <div class="mb-3"><label>Password</label><input type="password" name="password" id="password" class="form-control"/></div>
                <div class="mb-3"><label>Phone</label><input type="text" name="phone" id="phone" class="form-control"/></div>
            </div>
            <div class="modal-footer"><button type="submit" class="btn btn-primary">Save</button></div>
        </form>
    </div></div>
</div>

<script>
function loadData(){
    $.getJSON(contextPath+"/api/user", function(data){
        let rows="";
        data.forEach(u=>{
            rows+=`<tr>
                <td>${u.id}</td>
                <td>${u.fullname}</td>
                <td>${u.email}</td>
                <td>${u.phone}</td>
                <td>
                    <button class="btn btn-warning btn-sm" onclick='edit(${JSON.stringify(u)})'><i class="fa fa-edit"></i></button>
                    <button class="btn btn-danger btn-sm" onclick="remove(${u.id})"><i class="fa fa-trash"></i></button>
                </td>
            </tr>`;
        });
        $("#tableBody").html(rows);
    });
}
function showCreateModal(){ $("#id").val(""); $("#fullname,#email,#password,#phone").val(""); $("#formModal").modal("show"); }
function edit(u){ $("#id").val(u.id); $("#fullname").val(u.fullname); $("#email").val(u.email); $("#password").val(u.password); $("#phone").val(u.phone); $("#formModal").modal("show"); }
$("#formData").submit(function(e){
    e.preventDefault();
    let formData = $(this).serialize();
    let url = $("#id").val()?"/api/user/update":"/api/user/add";
    let method = $("#id").val()?"PUT":"POST";
    $.ajax({url:contextPath+url,type:method,data:formData,success:function(){ $("#formModal").modal("hide"); loadData(); }});
});
function remove(id){ if(confirm("Delete?")) $.ajax({url:contextPath+"/api/user/delete?id="+id,type:"DELETE",success:loadData}); }
$(document).ready(loadData);
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>