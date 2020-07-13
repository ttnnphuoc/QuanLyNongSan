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
    public class SQLGOIYsController : Controller
    {
        private QLCUNGUNGEntities db = new QLCUNGUNGEntities();

        // GET: SQLGOIYs
        public ActionResult Index()
        {
            return View(db.SQLGOIYs.ToList());
        }

        // GET: SQLGOIYs/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            SQLGOIY sQLGOIY = db.SQLGOIYs.Find(id);
            if (sQLGOIY == null)
            {
                return HttpNotFound();
            }
            return View(sQLGOIY);
        }

        // GET: SQLGOIYs/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: SQLGOIYs/Create
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "ID,NameTable,Name,SqlString")] SQLGOIY sQLGOIY)
        {
            if (ModelState.IsValid)
            {
                List<SQLGOIY> sqlItem = db.SQLGOIYs.OrderByDescending(x => x.ID).ToList();

                string tagName = "";
                switch (sQLGOIY.NameTable)
                {
                    case "Sản Phẩm":
                        tagName = "_SP";
                        break;
                    case "Nhân Viên":
                        tagName = "_NV";
                        break;
                    case "Đơn Hàng Xuất":
                        tagName = "_DHX";
                        break;
                    case "Đơn Hàng Nhập":
                        tagName = "_DHN";
                        break;
                    case "Đại Lý":
                        tagName = "_DL";
                        break;
                    case "Lưu Vết":
                        tagName = "_LV";
                        break;
                }

                sQLGOIY.Name += (sqlItem != null && sqlItem.Count > 0) ? "(" + (sqlItem[0].ID + 1) + ")"+ tagName : "(1)"+ tagName;

                db.SQLGOIYs.Add(sQLGOIY);
                db.SaveChanges();
                return RedirectToAction("Create");
            }

            return View(sQLGOIY);
        }

        // GET: SQLGOIYs/Edit/5
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            SQLGOIY sQLGOIY = db.SQLGOIYs.Find(id);
            if (sQLGOIY == null)
            {
                return HttpNotFound();
            }
            return View(sQLGOIY);
        }

        // POST: SQLGOIYs/Edit/5
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "ID,NameTable,Name,SqlString")] SQLGOIY sQLGOIY)
        {
            if (ModelState.IsValid)
            {
                db.Entry(sQLGOIY).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            return View(sQLGOIY);
        }

        // GET: SQLGOIYs/Delete/5
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            SQLGOIY sQLGOIY = db.SQLGOIYs.Find(id);
            if (sQLGOIY == null)
            {
                return HttpNotFound();
            }
            return View(sQLGOIY);
        }

        // POST: SQLGOIYs/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            SQLGOIY sQLGOIY = db.SQLGOIYs.Find(id);
            db.SQLGOIYs.Remove(sQLGOIY);
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
