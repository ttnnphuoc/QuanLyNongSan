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

    public partial class DONHANGNHAP
    {
        public int MaDHN { get; set; }

        [Required(ErrorMessage = "Không được bỏ trống")]
        [DisplayName("NCC")]
        public int MaNhaCC { get; set; }

        [Required(ErrorMessage = "Không được bỏ trống")]
        [DisplayName("Ngày Nhập")]
        [DisplayFormat(DataFormatString =("{0:dd/MM/yyyy}"))]
        public Nullable<System.DateTime> NgayNhap { get; set; }

        [Required(ErrorMessage = "Không được bỏ trống")]
        [DisplayName("Nhân Viên")]
        public Nullable<int> MaNV { get; set; }

        [Required(ErrorMessage = "Không được bỏ trống")]
        public string [] MaSP { get; set; }
        public Nullable<int> SoLuong { get; set; }

        [DisplayName("Xóa")]
        public Nullable<bool> isXoa { get; set; }
        public Nullable<int> ThoiGian { get; set; }
        public string PhuongTien { get; set; }
    }
}
