#!/bin/bash
#
# This script is written by me XD
# written to be used on debian plesk servers 
# to be invoked by cron job daily
# change date parameter if you need a backup per hour or minute
# licensed under gplv3
#You should have received a copy of the GNU General Public License along with this program. 
#If not, see http://www.gnu.org/licenses/.
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#THE SOFTWARE. 

mkdir -p /private-backup
cd /private-backup
if [ -f "dumpmysql.db.1.oldest.gz" ]; then
#echo "firstif" #used for debug
rm dumpmysql.db.fom.*.gz #fom first of month
mv dumpmysql.db.1.oldest.gz dumpmysql.db.fom.$(date +%Y%m).gz
fi

if [ -f dumpmysql.db.*.previous.gz ]; then
#echo "secif" #used for debug
PREVIOUSFILE=$(ls dumpmysql.db.*.previous.gz);
mv dumpmysql.db.${PREVIOUSFILE:13:2}.previous.gz dumpmysql.db.${PREVIOUSFILE:13:2}.oldest.gz
else
echo $PREVIOUSFILE "<-NPRFILE"
fi

if [ -f dumpmysql.db.*.latest.gz ]; then
#echo "thirif" #used for debug
LATESTFILE=$(ls dumpmysql.db.*.latest.gz);
mv dumpmysql.db.${LATESTFILE:13:2}.latest.gz dumpmysql.db.${LATESTFILE:13:2}.previous.gz
else
echo $LATESTFILE "<-NPRFILE"
fi
#mainpart edited for plesk
MYSQL_PWD=`cat /etc/psa/.psa.shadow`; mysqldump -x --all-databases \
-u admin -p$MYSQL_PWD | gzip > dumpmysql.db.$(date +%d).latest.gz
