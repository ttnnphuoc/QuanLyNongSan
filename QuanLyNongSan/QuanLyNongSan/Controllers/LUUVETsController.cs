using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using QuanLyNongSan.Models;
using VDS.RDF;
using VDS.RDF.Query;
using System.IO;
using System.Reflection;
using VDS.RDF.Writing.Formatting;
using System.Xml.Linq;
using QuanLyNongSan.Models.AccessData;

namespace QuanLyNongSan.Controllers
{
    public class LUUVETsController : Controller
    {
        private QLCUNGUNGEntities db = new QLCUNGUNGEntities();
        private GhiLog ghilog = new GhiLog();

        // GET: LUUVETs
        public ActionResult Index()
        {
            if (Session["username"] == null)
            {
                return RedirectToAction("Login", "TaiKhoans");
            }

            ViewBag.IsAdmin = "hidden-menu";
            ViewBag.Add = "disable-btn";
            if (isAdmin(Session["username"] + ""))
            {
                ViewBag.Add = "";
                ViewBag.IsAdmin = "";
            }
            //ReadFileOwl();
            ViewBag.NhanVien = db.NHANVIENs.Where(x=>x.isXoa == false).ToList();
            ViewBag.Tram = db.TRAMs.Where(x=>x.isXoa == false).ToList();
            return View(db.LUUVETs.Where(x=>x.isXoa == false).ToList());
        }
        private bool isAdmin(string username)
        {
            TAIKHOAN tk = db.TAIKHOANs.FirstOrDefault(x => x.TaiKhoan1 == username);
            if (tk != null && tk.ISADMIN != null && (bool)tk.ISADMIN)
            {
                return true;
            }
            return false;
        }
    
        // GET: LUUVETs/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            LUUVET lUUVET = db.LUUVETs.Where(x => x.MaDHX == id).First();
            if (lUUVET == null)
            {
                return HttpNotFound();
            }
            return View(lUUVET);
        }

        // GET: LUUVETs/Edit/5
        public ActionResult Edit(int? id)
        {
            if (Session["username"] == null)
            {
                return RedirectToAction("Login", "TaiKhoans");
            }
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            LUUVET lUUVET = db.LUUVETs.Where(x => x.MaDHX == id && x.isXoa == false).First();
            if (lUUVET == null)
            {
                return HttpNotFound();
            }
            ViewBag.NhanVien = db.NHANVIENs.Where(x => x.isXoa == false).ToList();
            ViewBag.Tram = db.TRAMs.Where(x => x.isXoa == false).ToList();
            return View(lUUVET);
        }

        // POST: LUUVETs/Edit/5
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        public ActionResult Edit([Bind(Include = "MaDHX,MaTram,MaNV,TrangThai,isXoa")] LUUVET lUUVET)
        {
            if (ModelState.IsValid)
            {
                LUUVET lvCu = db.LUUVETs.AsNoTracking().FirstOrDefault(x => x.MaDHX == lUUVET.MaDHX);
                string str = "<b>Mã DHX:</b> " + lvCu.MaDHX + "</br>";

                if (lvCu.MaNV != lUUVET.MaNV)
                {
                    NHANVIEN nvCu = db.NHANVIENs.AsNoTracking().FirstOrDefault(x => x.MaNV == lvCu.MaNV);
                    NHANVIEN nvMoi = db.NHANVIENs.AsNoTracking().FirstOrDefault(x => x.MaNV == lUUVET.MaNV);
                    str += "<b>Nhân Viên:</b> " + nvCu.Hoten + " => " + nvMoi.Hoten + "</br>";
                }

                
                if (lvCu.MaTram != lUUVET.MaTram)
                {
                    TRAM tramCu = db.TRAMs.AsNoTracking().FirstOrDefault(x => x.MaTram == lvCu.MaTram);
                    TRAM tramMoi = db.TRAMs.AsNoTracking().FirstOrDefault(x => x.MaTram == lUUVET.MaTram);
                    str += "<b>Nhân Viên:</b> " + tramCu.TenTram + " => " + tramMoi.TenTram + "</br>";
                }

                LUUVET lv = new LUUVET()
                {
                    isXoa = false,
                    MaDHX = lUUVET.MaDHX,
                    TrangThai = lUUVET.TrangThai,
                    MaTram = lUUVET.MaTram,
                    MaNV = lUUVET.MaNV
                };

                db.Entry(lv).State = EntityState.Modified;
                db.SaveChanges();
                
                str += "<b>Trạng Thái:</b> " + lvCu.TrangThai + " => " + lv.TrangThai + "</br>";
                ghilog.AddNewGhiLog("Sửa", Session["username"] + "", str, "Lưu Vết");

                return RedirectToAction("Index");
            }
            return View(lUUVET);
        }
        public ActionResult Delete(int id)
        {
            if (Session["username"] == null)
            {
                return RedirectToAction("Login", "TaiKhoans");
            }
            LUUVET lUUVET = db.LUUVETs.Where(x => x.MaDHX == id).First();
            if (lUUVET == null)
            {
                return HttpNotFound();
            }
            lUUVET.isXoa = true;
            db.Entry(lUUVET).State = EntityState.Modified;
            db.SaveChanges();
            ghilog.AddNewGhiLog("Xóa", Session["username"] + "", "Đã xóa lưu vết của đơn hàng " + lUUVET.MaDHX, "Lưu Vết");

            return RedirectToAction("Index");
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }
    }
}
