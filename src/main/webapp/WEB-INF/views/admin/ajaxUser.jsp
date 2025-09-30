<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>User Management</title>
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
        <h2 class="mb-0">User Management (Ajax)</h2>
        <button class="btn btn-success btn-add" onclick="showCreateModal()"><i class="fa fa-plus"></i> Add User</button>
    </div>
    <div class="card-body">
        <div class="table-responsive">
            <table class="table table-bordered table-striped table-hover">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Fullname</th>
                        <th>Email</th>
                        <th>Phone</th>
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
            <form id="formData">
                <div class="modal-header">
                    <h5 class="modal-title">User Details</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="id" id="id"/>
                    <div class="mb-3">
                        <label class="form-label">Fullname</label>
                        <input type="text" name="fullname" id="fullname" class="form-control" placeholder="Enter full name" required/>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Email</label>
                        <input type="email" name="email" id="email" class="form-control" placeholder="Enter email" required/>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Password</label>
                        <input type="password" name="password" id="password" class="form-control" placeholder="Enter password"/>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Phone</label>
                        <input type="text" name="phone" id="phone" class="form-control" placeholder="Enter phone number"/>
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
    $.getJSON(contextPath + "/api/user", function(data){
        let rows = "";
        data.forEach(u => {
            rows += `<tr>
                <td>${u.id}</td>
                <td>${u.fullname}</td>
                <td>${u.email}</td>
                <td>${u.phone}</td>
                <td>
                    <button class="btn btn-warning btn-sm me-1" onclick='edit(${JSON.stringify(u)})'><i class="fa fa-edit"></i> Edit</button>
                    <button class="btn btn-danger btn-sm" onclick="remove(${u.id})"><i class="fa fa-trash"></i> Delete</button>
                </td>
            </tr>`;
        });
        $("#tableBody").html(rows);
    });
}
function showCreateModal(){ $("#id").val(""); $("#formData")[0].reset(); $("#formModal").modal("show"); }
function edit(u){ $("#id").val(u.id); $("#fullname").val(u.fullname); $("#email").val(u.email); $("#password").val(u.password); $("#phone").val(u.phone); $("#formModal").modal("show"); }
$("#formData").submit(function(e){
    e.preventDefault();
    let formData = $(this).serialize();
    let url = $("#id").val() ? "/api/user/update" : "/api/user/add";
    let method = $("#id").val() ? "PUT" : "POST";
    $.ajax({
        url: contextPath + url,
        type: method,
        data: formData,
        success: function(){
            $("#formModal").modal("hide");
            loadData();
        }
    });
});
function remove(id){ if(confirm("Are you sure you want to delete this user?")) $.ajax({url: contextPath + "/api/user/delete?id=" + id, type: "DELETE", success: loadData}); }
$(document).ready(loadData);
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</body>
</html>