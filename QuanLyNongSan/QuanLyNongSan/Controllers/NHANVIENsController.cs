using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using QuanLyNongSan.Models;

namespace QuanLyNongSan.Controllers
{
    public class NHANVIENsController : Controller
    {
        private QLCUNGUNGEntities db = new QLCUNGUNGEntities();
        // GET: NHANVIENs
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
            return View(db.NHANVIENs.Where(x=>x.isXoa == false).ToList());
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
        // GET: NHANVIENs/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            NHANVIEN nHANVIEN = db.NHANVIENs.Find(id);
            if (nHANVIEN == null)
            {
                return HttpNotFound();
            }
            return View(nHANVIEN);
        }

        // GET: NHANVIENs/Create
        public ActionResult Create()
        {
            if (Session["username"] == null)
            {
                return RedirectToAction("Login", "TaiKhoans");
            }
            return View();
        }

        // POST: NHANVIENs/Create
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "MaNV,Hoten,Ngaysinh,Gioitinh,Ngayvaolam,isXoa")] NHANVIEN nHANVIEN)
        {
            if (ModelState.IsValid)
            {
                nHANVIEN.isXoa = false;
                db.NHANVIENs.Add(nHANVIEN);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            return View(nHANVIEN);
        }

        // GET: NHANVIENs/Edit/5
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
            NHANVIEN nHANVIEN = db.NHANVIENs.Find(id);
            if (nHANVIEN == null)
            {
                return HttpNotFound();
            }
            return View(nHANVIEN);
        }

        // POST: NHANVIENs/Edit/5
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "MaNV,Hoten,Ngaysinh,Gioitinh,Ngayvaolam,isXoa")] NHANVIEN nHANVIEN)
        {
            if (ModelState.IsValid)
            {
                nHANVIEN.isXoa = false;
                db.Entry(nHANVIEN).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            return View(nHANVIEN);
        }

        public ActionResult Delete(int id)
        {
            if (Session["username"] == null)
            {
                return RedirectToAction("Login", "TaiKhoans");
            }
            NHANVIEN nHANVIEN = db.NHANVIENs.Find(id);
            if (nHANVIEN == null)
            {
                return HttpNotFound();
            }
            nHANVIEN.isXoa = true;
            db.Entry(nHANVIEN).State = EntityState.Modified;
            db.SaveChanges();
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
