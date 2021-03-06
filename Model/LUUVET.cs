﻿//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace QuanLyNongSan.Models
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel;
    using System.ComponentModel.DataAnnotations;

    public partial class LUUVET
    {
        [DisplayName("Mã Đơn Hàng Xuất")]
        public int MaDHX { get; set; }

        [Required(ErrorMessage = "Không được bỏ trống")]
        [DisplayName("Trạm")]
        public int MaTram { get; set; }

        [Required(ErrorMessage = "Không được bỏ trống")]
        [DisplayName("Nhân Viên")]
        public int MaNV { get; set; }

        [DisplayName("Trạng Thái")]
        public Nullable<bool> TrangThai { get; set; }
        [DisplayName("Xóa")]
        public Nullable<bool> isXoa { get; set; }
    }
}
