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
    public class TRAMsController : Controller
    {
        private QLCUNGUNGEntities db = new QLCUNGUNGEntities();

        // GET: TRAMs
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
            return View(db.TRAMs.Where(x=>x.isXoa == false).ToList());
        }

        // GET: TRAMs/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            TRAM tRAM = db.TRAMs.Find(id);
            if (tRAM == null)
            {
                return HttpNotFound();
            }
            return View(tRAM);
        }

        // GET: TRAMs/Create
        public ActionResult Create()
        {
            if (Session["username"] == null)
            {
                return RedirectToAction("Login", "TaiKhoans");
            }
            return View();
        }

        // POST: TRAMs/Create
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "MaTram,TenTram,isXoa")] TRAM tRAM)
        {
            if (ModelState.IsValid)
            {
                tRAM.isXoa = false;
                db.TRAMs.Add(tRAM);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            return View(tRAM);
        }

        // GET: TRAMs/Edit/5
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
            TRAM tRAM = db.TRAMs.Find(id);
            if (tRAM == null)
            {
                return HttpNotFound();
            }
            return View(tRAM);
        }

        // POST: TRAMs/Edit/5
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "MaTram,TenTram,isXoa")] TRAM tRAM)
        {
            if (ModelState.IsValid)
            {
                tRAM.isXoa = false;
                db.Entry(tRAM).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            return View(tRAM);
        }

        public ActionResult Delete(int id)
        {
            if (Session["username"] == null)
            {
                return RedirectToAction("Login", "TaiKhoans");
            }
            TRAM tRAM = db.TRAMs.Find(id);
            if (tRAM == null)
            {
                return HttpNotFound();
            }
            tRAM.isXoa = true;
            db.Entry(tRAM).State = EntityState.Modified;
            db.SaveChanges();
            return RedirectToAction("Index");
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
