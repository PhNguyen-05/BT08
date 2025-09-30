<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Category Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" integrity="sha512-Kc323vGBEqzTmouAECnVceyQqyqdsSiqLQISBL29aUW4U/M7pSPA/gEUZQqv1cwx4OnYxTxvA5OBs9v4Qd6L0w==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <script src="https://code.jquery.com/jquery-3.7.1.min.js" integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>
    <script>var contextPath = "${pageContext.request.contextPath}"</script>
    <style>
        body {
            background-color: #f8f9fa;
        }
        .card {
            border-radius: 15px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        .table th {
            background-color: #007bff;
            color: white;
        }
        .table img {
            border-radius: 5px;
            object-fit: cover;
        }
        .btn-add {
            transition: all 0.3s ease;
        }
        .btn-add:hover {
            transform: translateY(-2px);
        }
        .modal-content {
            border-radius: 15px;
        }
        .modal-header {
            background-color: #007bff;
            color: white;
            border-top-left-radius: 15px;
            border-top-right-radius: 15px;
        }
    </style>
</head>
<body class="container mt-5">

<div class="card">
    <div class="card-header d-flex justify-content-between align-items-center">
        <h2 class="mb-0">Category Management (Ajax)</h2>
        <button class="btn btn-success btn-add" onclick="showCreateModal()"><i class="fa fa-plus"></i> Add Category</button>
    </div>
    <div class="card-body">
        <div class="table-responsive">
            <table class="table table-bordered table-striped table-hover">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Image</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody id="tableBody"></tbody>
            </table>
        </div>
    </div>
</div>

<!-- Modal -->
<div class="modal fade" id="formModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <form id="formData" enctype="multipart/form-data">
                <div class="modal-header">
                    <h5 class="modal-title">Category Details</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="categoryId" id="id"/>
                    <div class="mb-3">
                        <label class="form-label">Name</label>
                        <input type="text" name="categoryName" id="name" class="form-control" placeholder="Enter category name" required/>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Image</label>
                        <input type="file" name="icon" id="icon" class="form-control" accept="image/*"/>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Save Changes</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
function loadData(){
    $.getJSON(contextPath + "/api/category", function(data){
        let rows = "";
        data.forEach(c => {
            rows += `<tr>
                <td>${c.categoryId}</td>
                <td>${c.categoryName}</td>
                <td>${c.icon ? '<img src="' + contextPath + '/uploads/' + c.icon + '" width="50" height="50" alt="Category Image"/>' : 'No Image'}</td>
                <td>
                    <button class="btn btn-warning btn-sm me-1" onclick='edit(${JSON.stringify(c)})'><i class="fa fa-edit"></i> Edit</button>
                    <button class="btn btn-danger btn-sm" onclick="remove(${c.categoryId})"><i class="fa fa-trash"></i> Delete</button>
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
    let url = $("#id").val() ? "/api/category/updateCategory" : "/api/category/addCategory";
    let method = $("#id").val() ? "PUT" : "POST";
    $.ajax({
        url: contextPath + url,
        type: method,
        data: formData,
        processData: false,
        contentType: false,
        success: function(){
            $("#formModal").modal("hide");
            loadData();
        }
    });
});
function remove(id){ if(confirm("Are you sure you want to delete this category?")) $.ajax({url: contextPath + "/api/category/deleteCategory?categoryId=" + id, type: "DELETE", success: loadData}); }
$(document).ready(loadData);
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</body>
</html>