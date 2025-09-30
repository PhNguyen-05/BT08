<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Product CRUD</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.1/css/all.min.css"/>
    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
    <script>var contextPath = "${pageContext.request.contextPath}"</script>
</head>
<body class="container mt-5">

<h2 class="mb-4">Product CRUD (Ajax)</h2>
<p><button class="btn btn-success" onclick="showCreateModal()"><i class="fa fa-plus"></i> Add Product</button></p>

<table class="table table-bordered table-striped">
    <thead><tr><th>ID</th><th>Title</th><th>Quantity</th><th>Price</th><th>Category</th><th>Actions</th></tr></thead>
    <tbody id="tableBody"></tbody>
</table>

<div class="modal fade" id="formModal" tabindex="-1">
    <div class="modal-dialog"><div class="modal-content">
        <form id="formData">
            <div class="modal-header"><h5 class="modal-title">Product</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
            <div class="modal-body">
                <input type="hidden" name="id" id="id"/>
                <div class="mb-3"><label>Title</label><input type="text" name="title" id="title" class="form-control"/></div>
                <div class="mb-3"><label>Quantity</label><input type="number" name="quantity" id="quantity" class="form-control"/></div>
                <div class="mb-3"><label>Price</label><input type="number" name="price" id="price" class="form-control"/></div>
                <div class="mb-3"><label>Description</label><textarea name="desc" id="desc" class="form-control"></textarea></div>
                <div class="mb-3"><label>Category ID</label><input type="number" name="categoryId" id="categoryId" class="form-control"/></div>
            </div>
            <div class="modal-footer"><button type="submit" class="btn btn-primary">Save</button></div>
        </form>
    </div></div>
</div>

<script>
function loadData(){
    $.getJSON(contextPath+"/api/product", function(data){
        let rows="";
        data.forEach(p=>{
            rows+=`<tr>
                <td>${p.id}</td>
                <td>${p.title}</td>
                <td>${p.quantity}</td>
                <td>${p.price}</td>
                <td>${p.category? p.category.name : ""}</td>
                <td>
                    <button class="btn btn-warning btn-sm" onclick='edit(${JSON.stringify(p)})'><i class="fa fa-edit"></i></button>
                    <button class="btn btn-danger btn-sm" onclick="remove(${p.id})"><i class="fa fa-trash"></i></button>
                </td>
            </tr>`;
        });
        $("#tableBody").html(rows);
    });
}
function showCreateModal(){ $("#id").val(""); $("#formData")[0].reset(); $("#formModal").modal("show"); }
function edit(p){ $("#id").val(p.id); $("#title").val(p.title); $("#quantity").val(p.quantity); $("#price").val(p.price); $("#desc").val(p.desc); $("#categoryId").val(p.category? p.category.id:""); $("#formModal").modal("show"); }
$("#formData").submit(function(e){
    e.preventDefault();
    let formData = $(this).serialize();
    let url = $("#id").val()?"/api/product/update":"/api/product/add";
    let method = $("#id").val()?"PUT":"POST";
    $.ajax({url:contextPath+url,type:method,data:formData,success:function(){ $("#formModal").modal("hide"); loadData(); }});
});
function remove(id){ if(confirm("Delete?")) $.ajax({url:contextPath+"/api/product/delete?id="+id,type:"DELETE",success:loadData}); }
$(document).ready(loadData);
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>