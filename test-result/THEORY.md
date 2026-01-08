# Strategi Arsitektur Audit Trail

## Pertanyaan
Jika diperlukan penambahan kolom `created_by` (user_id) dan `updated_at` (timestamp) ke setiap tabel sebagai mekanisme **Audit Trail**, bagaimana pendekatan efisien di Laravel agar tidak terjadi pengulangan kode (*code duplication*) di setiap Controller?

## Jawaban

Untuk mematuhi prinsip **DRY (Don't Repeat Yourself)** dan menjaga konsistensi data di seluruh aplikasi, saya mengusulkan dua pendekatan arsitektural. Pemilihan metode bergantung pada apakah proyek mengizinkan penggunaan Eloquent Model atau dibatasi hanya pada Query Builder (seperti pada batasan Bagian B tes ini).

### Pendekatan 1: Menggunakan Eloquent (Rekomendasi Standar)
Dalam lingkungan Laravel standar di mana Eloquent ORM digunakan, metode yang paling efisien, bersih, dan otomatis adalah menggunakan **Traits** yang dikombinasikan dengan **Model Boot Events**.

**Strategi Implementasi:**
1.  Membuat Trait bernama `HasAuditTrail`.
2.  Menggunakan metode `bootHasAuditTrail` (naming convention Laravel) untuk melakukan *hook* ke event siklus hidup model, yaitu `creating` dan `updating`.

**Contoh Kode:**
```php
trait HasAuditTrail
{
    public static function bootHasAuditTrail()
    {
        // Event sebelum record dibuat (Insert)
        static::creating(function ($model) {
            $model->created_at = now();
            $model->updated_at = now();
            // Cek apakah user sedang login (untuk support context CLI/Job)
            if (auth()->check()) {
                $model->created_by = auth()->id();
            }
        });

        // Event sebelum record diubah (Update)
        static::updating(function ($model) {
            $model->updated_at = now();
            if (auth()->check()) {
                // Asumsi kolom 'updated_by' tersedia
                $model->updated_by = auth()->id(); 
            }
        });
    }
}