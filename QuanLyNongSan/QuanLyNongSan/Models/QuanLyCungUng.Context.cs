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
    using System.Data.Entity;
    using System.Data.Entity.Infrastructure;
    
    public partial class QLCUNGUNGEntities : DbContext
    {
        public QLCUNGUNGEntities()
            : base("name=QLCUNGUNGEntities")
        {
        }
    
        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            throw new UnintentionalCodeFirstException();
        }
    
        public virtual DbSet<CHITIETDONHANGNHAP> CHITIETDONHANGNHAPs { get; set; }
        public virtual DbSet<CHITIETDONHANGXUAT> CHITIETDONHANGXUATs { get; set; }
        public virtual DbSet<DAILY> DAILies { get; set; }
        public virtual DbSet<DONHANGNHAP> DONHANGNHAPs { get; set; }
        public virtual DbSet<LOAIDAILY> LOAIDAILies { get; set; }
        public virtual DbSet<LOAISANPHAM> LOAISANPHAMs { get; set; }
        public virtual DbSet<LUUVET> LUUVETs { get; set; }
        public virtual DbSet<NHACUNGCAP> NHACUNGCAPs { get; set; }
        public virtual DbSet<NHANVIEN> NHANVIENs { get; set; }
        public virtual DbSet<SANPHAM> SANPHAMs { get; set; }
        public virtual DbSet<TAIKHOAN> TAIKHOANs { get; set; }
        public virtual DbSet<TRAM> TRAMs { get; set; }
        public virtual DbSet<DONHANGXUAT> DONHANGXUATs { get; set; }
        public virtual DbSet<SQLGOIY> SQLGOIYs { get; set; }
    }
}
