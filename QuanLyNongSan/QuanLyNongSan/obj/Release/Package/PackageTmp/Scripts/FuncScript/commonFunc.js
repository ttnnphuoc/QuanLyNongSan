function getInfoProduct(id) {
    $('#loading').show();

    $.ajax({
        url: "/SANPHAMs/GetInfoProduct/",
        type: "Post",
        data: { id: id },
        success: function (data) {
            var htmlInfo = "";
            if (data) {
                var ghiChu = data.output.Ghichu ? data.output.Ghichu : "";
                htmlInfo = "<table class='table'>"+
                          "<tbody>"+
                           " <tr>"+
                            "  <th scope='row'>Mã</th>"+
                             " <td>" + data.output.MaSP + "</td>" +
                              
                            "</tr>"+
                            "<tr>"+
                             " <th scope='row'>Loại</th>"+
                              " <td>" + data.loai + "</td>" +
                              
                            "</tr>"+
                            "<tr>"+
                             " <th scope='row'>Nhà cung cấp</th>"+
                              " <td>" + data.ncc + "</td>" +
                            "</tr>" +
                            "<tr>" +
                             " <th scope='row'>Tên</th>" +
                              " <td>" + data.output.TenSP + "</td>" +
                            "</tr>" +
                            "<tr>" +
                             " <th scope='row'>Trọng lượng</th>" +
                              " <td>" + data.output.TrongLuong + " kg</td>" +
                            "</tr>" +
                            "<tr>" +
                             " <th scope='row'>Hạn sử dụng</th>" +
                              " <td>" + data.output.ThoiHanSuDung + " Tháng</td>" +
                            "</tr>" +
                            "<tr>" +
                             " <th scope='row'>Quy cách</th>" +
                              " <td>" + data.output.QuyCachDongGoi + "</td>" +
                            "</tr>" +
                            "<tr>" +
                             " <th scope='row'>Giá</th>" +
                              " <td>" + formatCurrency(data.output.Gia) + "</td>" +
                            "</tr>" +
                            "<tr>" +
                             " <th scope='row'>Thời Gian</th>" +
                              " <td>" + data.output.ThoiGian + "</td>" +
                            "</tr>" +
                            "<tr>" +
                             " <th scope='row'>Bảo Quản</th>" +
                              " <td>" + data.output.BaoQuan + "</td>" +
                            "</tr>" +
                            "<tr>" +
                             " <th scope='row'>Ghi chú</th>" +
                              " <td>" + ghiChu + "</td>" +
                            "</tr>" +
                "</tbody>"+
                "</table>";
                $("#info-product .modal-body").html(htmlInfo);
            }
            console.log(data);
            $('#loading').hide();
            $("#info-product").modal().show();
        },
        error: function(error) {
            $('#loading').hide();
        }
    });
}

function formatCurrency(number) {
    var partNum = 3;
    var mark = ".";
    var newNum = number + "";
    var min = "-";
    if (number < 0) {
        newNum = newNum.split("-")[1];
    }
    var lengNum = newNum.length;

    for (var i = lengNum; i > 0; i--) {
        if (i % partNum === 0 && i !== lengNum) {
            var ltNum = newNum.slice(0, -i);
            var rtNum = newNum.slice(-i);
            newNum = ltNum + mark + rtNum;
        }
    }
    if (number < 0) {
        newNum = min + newNum;
    }
    return newNum;
}