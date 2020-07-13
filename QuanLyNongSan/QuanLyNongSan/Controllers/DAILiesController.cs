using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using QuanLyNongSan.Models;
using QuanLyNongSan.Models.AccessData;

namespace QuanLyNongSan.Controllers
{
    public class DAILiesController : Controller
    {
        private QLCUNGUNGEntities db = new QLCUNGUNGEntities();
        GhiLog ghiLog = new GhiLog();

        // GET: DAILies
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
            ViewBag.LoaiDaiLy = db.LOAIDAILies.ToList();
            return View(db.DAILies.Where(x=>x.isXoa == false).ToList());
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
        // GET: DAILies/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            DAILY dAILY = db.DAILies.Find(id);
            if (dAILY == null)
            {
                return HttpNotFound();
            }
            return View(dAILY);
        }

        // GET: DAILies/Create
        public ActionResult Create()
        {
            if (Session["username"] == null)
            {
                return RedirectToAction("Login", "TaiKhoans");
            }
            ViewBag.LoaiDaiLy = db.LOAIDAILies.Where(x=>x.isXoa == false).ToList();
            return View();
        }

        // POST: DAILies/Create
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "MaDL,MaLoai,Ten,SoDT,DiaChi,isXoa")] DAILY dAILY)
        {
            if (ModelState.IsValid)
            {
                dAILY.isXoa = false;
                db.DAILies.Add(dAILY);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            ViewBag.LoaiDaiLy = db.LOAIDAILies.ToList();
            return View(dAILY);
        }

        // GET: DAILies/Edit/5
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
            DAILY dAILY = db.DAILies.Find(id);
            if (dAILY == null)
            {
                return HttpNotFound();
            }
            return View(dAILY);
        }

        // POST: DAILies/Edit/5
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "MaDL,MaLoai,Ten,SoDT,DiaChi,isXoa")] DAILY dAILY)
        {
            if (ModelState.IsValid)
            {
                dAILY.isXoa = false;
                db.Entry(dAILY).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            return View(dAILY);
        }
        
        public ActionResult Delete(int id)
        {
            if (Session["username"] == null)
            {
                return RedirectToAction("Login", "TaiKhoans");
            }
            DAILY dAILY = db.DAILies.Find(id);
            if (dAILY == null)
            {
                return HttpNotFound();
            }
            dAILY.isXoa = true;
            db.Entry(dAILY).State = EntityState.Modified;
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
